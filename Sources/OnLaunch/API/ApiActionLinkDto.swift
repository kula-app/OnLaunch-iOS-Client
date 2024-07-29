struct ApiActionLinkDto: Decodable {
    enum Target: RawRepresentable, Decodable {
        case inAppBrowser
        case shareSheet
        case systemBrowser
        case unknown(String)

        init?(rawValue: String) {
            switch rawValue {
            case "IN_APP_BROWSER":
                self = .inAppBrowser
            case "SHARE_SHEET":
                self = .shareSheet
            case "SYSTEM_BROWSER":
                self = .systemBrowser
            default:
                self = .unknown(rawValue)
            }
        }

        var rawValue: String {
            switch self {
            case .inAppBrowser:
                return "IN_APP_BROWSER"
            case .shareSheet:
                return "SHARE_SHEET"
            case .systemBrowser:
                return "SYSTEM_BROWSER"
            case let .unknown(value):
                return value
            }
        }
    }

    let link: String?
    let target: Target?
}
