import SwiftUI

/// Modifier used to integrate OnLaunch with SwiftUI
public struct OnLaunchModifier: ViewModifier {

    /// Environment value used to track for scene updates
    @Environment(\.scenePhase) private var scenePhase

    /// State used to track the currently displayed message
    @State var currentMessage: Message?

    /// Configures OnLaunch with the given `configurationHandler` and conditionally presents the OnLaunch UI
    fileprivate init(configurationHandler: @escaping OnLaunch.ConfigurationHandler) {
        OnLaunch.configure { options in
            configurationHandler(options)

            // Set the internal flag to indicate the present logic to use the SwiftUI host system
            options.isSwiftUIHost = true

            options.shouldCheckOnConfigure = false
        }
    }

    @ViewBuilder
    public func body(content: Content) -> some View {
        // Listening for scene phase changes can be used to trigger OnLaunch checks
        let listeningContent = content
            .onChange(of: scenePhase) { newPhase in
                switch newPhase {
                case .active:
                    OnLaunch.check()
                default:
                    break
                }
            }
        if let client = OnLaunch.shared {
            listeningContent
                .onReceive(client.currentMessage) { message in
                    // Create an observer for the current message publisher
                    self.currentMessage = message
                }
                .sheet(item: $currentMessage) { message in
                    // If an message is set to the state, the view updates and presents the message
                    client.swiftUIContainerViewFor(message: message)
                }
        } else {
            listeningContent
                .onAppear {
                    // This assertion is just for sanity checking during development.
                    // It assures that the `OnLaunch.configure` handler located in the `init` of this view modifier
                    // is not removed by accident.
                    assertionFailure("OnLaunch failed to apply view modifier, because it is not configured yet. You should never see this error.")
                }
        }
    }
}

extension View {

    /// Configures OnLaunch with the given `configurationHandler` and conditionally presents the OnLaunch UI
    public func configureOnLaunch(_ configurationHandler: @escaping OnLaunch.ConfigurationHandler) -> some View {
        self.modifier(OnLaunchModifier(configurationHandler: configurationHandler))
    }
}
