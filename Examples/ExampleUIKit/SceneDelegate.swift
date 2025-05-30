import OnLaunch
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func sceneDidBecomeActive(_ scene: UIScene) {
        OnLaunch.configure { options in
            // Configure the public key to authenticate with the API endpoint
            options.publicKey = "K2UX4fVPFyixVaeLn8Fky_uWhjMr-frADqKqpOCZW2c"

            // Configure the host scene to present the UI
            options.hostScene = scene
            // or: configure the host view controller to present the UI
            // options.hostViewController = (scene as? UIWindowScene)?.keyWindow?.rootViewController

            // (Optional) Configure a custom base URL to your API host
            // options.baseURL = "https://your-domain.com/api"

            // (Optional) Configure the App Store id, required by the action 'OPEN_APP_IN_APP_STORE'
            options.appStoreId = 409_201_541
        }
    }
}
