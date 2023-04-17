import SwiftUI
import OnLaunch

@main
struct MainApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .configureOnLaunch { options in
                    // Configure the public key to authenticate with the API endpoint
                    options.publicKey = "K2UX4fVPFyixVaeLn8Fky_uWhjMr-frADqKqpOCZW2c"

                    // (Optional) Configure a custom base URL to your API host
                    // options.baseURL = "https://your-domain.com/api/v0.1"
                }
        }
    }
}
