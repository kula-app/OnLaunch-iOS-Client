import OSLog
import SwiftUI
import UIKit
import Combine

public class OnLaunch: NSObject {

    // MARK: - Types

    /// Options used to control the behaviour of OnLaunch
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

        /// Internal flag used to indicate that the SwiftUI host system is used
        internal var isSwiftUIHost = false
    }

    /// Closure used to modify the given options instance
    public typealias ConfigurationHandler = (Options) -> Void

    // MARK: - Public Static API

    /// Initializes and configures OnLaunch
    ///
    /// This method should only be called once from your `AppDelegate` or `SceneDelegate`
    @discardableResult public static func configure(_ configurationHandler: ConfigurationHandler) -> OnLaunch {
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

    /// Triggers the OnLaunch client to fetch messages from the remote and conditionally present them on the configured host UI
    ///
    /// Before calling this method, make sure that `OnLaunch.configure` has been called. If you are using the SwiftUI view modifier
    /// this will be done when the scene becomes active.
    public static func check() {
        guard let client = OnLaunch.shared else {
            return assertionFailure("OnLaunch failed to check for messages, because it is not configured yet.")
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
    internal var currentMessage = CurrentValueSubject<Message?, Never>(nil)

    /// Completion handler used by the SwiftUI implementation
    private var swiftUIDismissCompletionHandler: () -> Void = { }

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

    /// Helper function used to setup the completion handler for SwiftUI hosted views
    internal func swiftUIContainerViewFor(message: Message) -> some View {
        containerViewFor(message: message, completionHandler: swiftUIDismissCompletionHandler)
    }

    /// Creates the fully configured message view for the given `message`
    private func containerViewFor(message: Message, completionHandler: @escaping () -> Void) -> some View {
        MessageView(message: message, completionHandler: completionHandler)
            .environment(\.theme, options.theme)
    }

    // MARK: - Private Methods

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
        let filteredMessages = messages.filter { message in
            // Only include messages which are blocking or have not already been presented
            message.isBlocking || !storage.isMessageMarkedAsPresented(id: message.id)
        }
        os_log("%i messages need to be presented", log: .onlaunch, type: .debug, filteredMessages.count)
        messageQueue = filteredMessages
        processMessageQueue()
    }

    private func processMessageQueue() {
        os_log("Processing message queue with %i messages", log: .onlaunch, type: .debug, messageQueue.count)
        // If a message is already presented, that means the queue is already being processed
        guard currentMessage.value == nil else {
            os_log("Current message is not nil, ignoring call to process message queue", log: .onlaunch, type: .debug)
            return
        }
        // Take the first message in the queue
        guard let message = messageQueue.first else {
            os_log("No more messages to process", log: .onlaunch, type: .debug)
            return
        }
        os_log("Moved message with id %i from queue to current message", log: .onlaunch, type: .debug, message.id)
        messageQueue.remove(at: 0)
        currentMessage.send(message)

        present(message: message) { message in
            os_log("Completed presenting message %i", log: .onlaunch, type: .debug, message.id)
            self.currentMessage.send(nil)
            self.storage.markMessageAsPresented(id: message.id)
            self.processMessageQueue()
        }
    }

    private func present(message: Message, completionHandler: @escaping (Message) -> Void) {
        os_log("Presenting message with id %i", log: .onlaunch, type: .debug, message.id)
        // Check if the SwiftUI host system is used
        if options.isSwiftUIHost {
            swiftUIDismissCompletionHandler = {
                completionHandler(message)
            }
            return
        }

        // Otherwise present the view controller as usual using UIKit modal presentation
        let hostingController = UIHostingController(rootView: containerViewFor(message: message, completionHandler: {
            completionHandler(message)
        }))
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
