import SwiftUI
import OnLaunch

struct ContentView: View {
    var body: some View {
        Button("Tap me to check for new messages") {
            OnLaunch.check()
        }
    }
}
