import OSLog
import SwiftUI
import UIKit

public class OnLaunch {

    // MARK: - Types

    public class Options {

        /// Base URL where the OnLaunch API is hosted at.
        public var baseURL = "https://onlaunch.kula.app/v1/clients"

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

    // MARK: - Public Static API

    public static func configure(_ configurationHandler: (Options) -> Void) {
        let options = Options()
        configurationHandler(options)

        let client = OnLaunch(options: options)
        client.configure()
        self.shared = client

        if options.shouldCheckOnConfigure {
            check()
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

    internal var options: Options

    // MARK: - Internal Initializer

    internal init(options: Options) {
        self.options = options
    }

    // MARK: - Internal Methods

    /// Configures the client, i.e. registers for global notifications in the `NotificationCenter`
    private func configure() {
        // noop
    }

    /// Performs a check with the remote and reacts accordingly.
    private func check() {
        os_log("Checking for messages...", log: .onlaunch, type: .info)
        let message = Message(
            id: 1,
            title: "Freezing the energy consumption",
            body: "What would George do?\n\nWhen the energy prices are heating up it’s time to cool down and reduce the waste of energy and financial health. While that seems hard, start with the easy wins: for example, when did you defrost your freezer the last time? And by the way, for your normal fridge, 4 degree Celsius are cool enough. Each degree less means 5% more energy.",
            isBlocking: false,
            actions: [
                Action(kind: .button, title: "Thanks George!"),
                Action(kind: .button, title: "Sorry, not interested")
            ]
        )

        // Create the UI
        let rootView = MessageView(message: message)
            .environment(\.theme, options.theme)
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
