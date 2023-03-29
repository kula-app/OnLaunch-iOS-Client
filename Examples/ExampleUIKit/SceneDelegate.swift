import UIKit
import OnLaunch

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func sceneDidBecomeActive(_ scene: UIScene) {
        OnLaunch.configure { options in
            // Configure the public key to authenticate with the API endpoint
            options.publicKey = "TODO: setup an example"
            // Configure the host scene to present the UI
            options.hostScene = scene
            // or: configure the host view controller to present the UI
            // options.hostViewController = (scene as? UIWindowScene)?.keyWindow?.rootViewController
        }
    }
}

