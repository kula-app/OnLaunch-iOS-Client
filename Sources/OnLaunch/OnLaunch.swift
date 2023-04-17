import OSLog
import SwiftUI
import UIKit

public class OnLaunch: NSObject {

    // MARK: - Types

    public class Options {

        /// Base URL where the OnLaunch API is hosted at.
        public var baseURL = "https://onlaunch.kula.app/api/v0.1/"

        /// Public key used to authenticate with the API
        public var publicKey: String?

        /// Flag indicating if the client should automatically perform the check after configuration
        ///
        /// If this is set to `false` you need to manually call `OnLaunch.check()`.
        public var shouldCheckOnConfigure = true

        /// Scene used to host the OnLaunch UI
        public weak var hostScene: UIScene?

        /// View controller used to host the OnLaunch UI
        public weak var hostViewController: UIViewController?

        /// Custom theme used by the UI
        public var theme = Theme.standard
    }

    public typealias ConfigurationHandler = (Options) -> Void

    // MARK: - Public Static API

    @discardableResult
    public static func configure(_ configurationHandler: ConfigurationHandler) -> OnLaunch {
        if let client = OnLaunch.shared {
            os_log("OnLaunch is already configured, ignoring additional call", log: .onlaunch, type: .info)
            return client
        }
        do {
            let options = Options()
            configurationHandler(options)

            let client = try OnLaunch(options: options)
            try client.configure()
            self.shared = client

            if options.shouldCheckOnConfigure {
                check()
            }

            return client
        } catch {
            preconditionFailure("Failed to configure OnLaunch: \(error.localizedDescription)")
        }
    }

    public static func check() {
        guard let client = OnLaunch.shared else {
            os_log("OnLaunch failed to check for messages, because it is not configured yet",
                   log: .onlaunch, type: .error)
            return
        }
        client.check()
    }

    // MARK: - Internal Static State

    internal static var shared: OnLaunch?

    // MARK: - Internal State

    /// Options as defined by the library user
    internal var options: Options

    /// Instance used to store data
    internal let storage: LocalStorage

    /// The `URLSession` used to send API requests
    internal let session: URLSession

    /// URL used as the reference for all API calls, e.g. `https://onlaunch.kula.app/api/v0.1`
    private let baseURL: URL

    /// A `FIFO` queue of messages to present
    private var messageQueue: [Message] = []

    /// The message which is currently presented
    private var currentMessage: Message?

    // MARK: - Internal Initializer

    internal init(options: Options, storage: LocalStorage = LocalStorage(), session: URLSession = URLSession(configuration: .ephemeral)) throws {
        self.options = options
        guard let baseURL = URL(string: options.baseURL) else {
            throw OnLaunchError.invalidBaseURL(options.baseURL)
        }
        self.baseURL = baseURL
        self.storage = storage
        self.session = session
        super.init()
    }

    // MARK: - Internal Methods

    /// Configures the client, i.e. registers for global notifications in the `NotificationCenter`
    private func configure() throws {
        /// noop
    }

    /// Performs a check with the remote and reacts accordingly.
    private func check() {
        os_log("Checking for messages...", log: .onlaunch, type: .info)
        
        var request = URLRequest(url: baseURL
            .appendingPathComponent("messages"))
        request.setValue(options.publicKey, forHTTPHeaderField: "X-API-Key")

        requestMessages(request: request)
    }

    private func requestMessages(request: URLRequest) {
        Task {
            do {
                os_log("Sending HTTP request to '%@'", log: .onlaunch, type: .debug, request.url?.description ?? "nil")
                let (data, response) = try await self.session.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse else {
                    preconditionFailure("Expected HTTPURLResponse from URLSession, got: \(response)")
                }
                guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                    throw OnLaunchError.failedToFetchMessages(response: httpResponse, data: String(data: data, encoding: .utf8))
                }
                let decoder = JSONDecoder()
                let messages = try decoder.decode([ApiMessageResponseDto].self, from: data)
                os_log("Fetched %i messages", log: .onlaunch, type: .debug, messages.count)
                await MainActor.run {
                    self.process(messageDtos: messages)
                }
            } catch {
                os_log("Failed to check for OnLaunch messages, reason: %@", log: .onlaunch, type: .error, error.localizedDescription)
                os_log("Error: %@", log: .onlaunch, type: .error, (error as NSError).debugDescription)
            }
        }
    }

    private func process(messageDtos: [ApiMessageResponseDto]) {
        os_log("Processing %i messages", log: .onlaunch, type: .debug, messageDtos.count)
        // Map the DTO to the known message
        let messages = messageDtos.map { message in
            Message(id: message.id,
                    title: message.title,
                    body: message.body,
                    isBlocking: message.blocking,
                    actions: message.actions.compactMap { action in
                let kind: Action.Kind
                switch action.actionType {
                case .button:
                    kind = .button
                case .dismissButton:
                    kind = .dismissButton
                }
                return Action(kind: kind, title: action.title)
            })
        }
        // Filter messages which are not blocking and have already been presented
        let filteredMessages = messages.filter { message in
            message.isBlocking || !storage.isMessageMarkedAsPresented(id: message.id)
        }
        os_log("%i messages need to be presented", log: .onlaunch, type: .debug, filteredMessages.count)
        messageQueue = filteredMessages
        processMessageQueue()
    }

    private func processMessageQueue() {
        os_log("Processing message queue with %i messages", log: .onlaunch, type: .debug, messageQueue.count)
        // If a message is already presented, that means the queue is already being processed
        guard currentMessage == nil else {
            return
        }
        // Take the first message in the queue
        guard let message = messageQueue.first else {
            os_log("No more messages to process", log: .onlaunch, type: .debug)
            return
        }
        messageQueue.remove(at: 0)
        currentMessage = message

        present(message: message) { message in
            os_log("Completed presenting message %i", log: .onlaunch, type: .debug, message.id)
            self.currentMessage = nil
            self.storage.markMessageAsPresented(id: message.id)
            self.processMessageQueue()
        }
    }

    private func present(message: Message, completionHandler: @escaping (Message) -> Void) {
        // Create the UI
        let rootView = MessageView(message: message, completionHandler: {
            completionHandler(message)
        }).environment(\.theme, options.theme)
        let hostingController = UIHostingController(rootView: rootView)
        hostingController.isModalInPresentation = true

        // Find the view controller used to present the OnLaunch UI
        let presentingViewController: UIViewController
        if let scene = options.hostScene {
            os_log("Configured to use host scene: %@",
                   log: .onlaunch, type: .debug,
                   scene.description)
            guard let windowScene = scene as? UIWindowScene else {
                assertionFailure("Hosting scene is not an UIWindowScene, can't use it to present the UI")
                return
            }
            guard let keyViewController = windowScene.keyWindow?.rootViewController else {
                assertionFailure("Hosting scene has no key window or root view controller set, can't use it to the present the UI")
                return
            }
            presentingViewController = keyViewController
        } else if let configuredHostViewController = options.hostViewController {
            os_log("Configured to use host view controller: %@",
                   log: .onlaunch, type: .debug,
                   configuredHostViewController.description)
            presentingViewController = configuredHostViewController
        } else {
            assertionFailure("Host scene or view controller is not configured, did you forget to set it in 'OnLaunch.configure { ... }'?")
            return
        }
        presentingViewController.present(hostingController, animated: true)
    }
}
