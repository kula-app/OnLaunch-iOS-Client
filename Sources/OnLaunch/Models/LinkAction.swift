import Foundation

struct LinkAction {
    enum Target {
        case inAppBrowser
        case shareSheet
        case systemBrowser
    }

    let url: URL
    let target: Target?
}
