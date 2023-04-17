import SwiftUI

public struct OnLaunchModifier: ViewModifier {

    @Environment(\.scenePhase) var scenePhase

    private var configurationHandler: OnLaunch.ConfigurationHandler

    public init(configurationHandler: @escaping OnLaunch.ConfigurationHandler) {
        self.configurationHandler = configurationHandler
        OnLaunch.configure(configurationHandler)
    }

    public func body(content: Content) -> some View {
        // TODO: use the `content` as the host for the message views
        content
            .onChange(of: scenePhase) { newPhase in
                switch newPhase {
                case .active:
                    OnLaunch.check()
                default:
                    break
                }
            }
    }
}

extension View {

    public func configureOnLaunch(_ configurationHandler: @escaping OnLaunch.ConfigurationHandler) -> some View {
        self.modifier(OnLaunchModifier(configurationHandler: configurationHandler))
    }
}
