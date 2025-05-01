struct ApiActionDto: Decodable {
    enum ActionType: RawRepresentable, Decodable {
        case dismiss
        case link
        case openInAppStore
        case unknown(String)

        init?(rawValue: String) {
            switch rawValue {
            case "DISMISS":
                self = .dismiss
            case "LINK":
                self = .link
            case "OPEN_APP_IN_APP_STORE":
                self = .openInAppStore
            default:
                self = .unknown(rawValue)
            }
        }

        var rawValue: String {
            switch self {
            case .dismiss:
                return "DISMISS"
            case .link:
                return "LINK"
            case .openInAppStore:
                return "OPEN_APP_IN_APP_STORE"
            case let .unknown(value):
                return value
            }
        }
    }

    let actionType: ActionType
    let title: String

    let link: ApiActionLinkDto?
}
