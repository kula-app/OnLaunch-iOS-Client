struct ApiActionDto: Decodable {
    enum ActionType: RawRepresentable, Decodable {
        case dismiss
        case openInAppStore
        case unknown(String)

        init?(rawValue: String) {
            switch rawValue {
            case "DISMISS":
                self = .dismiss
            case "OPEN_IN_APP_STORE":
                self = .openInAppStore
            default:
                self = .unknown(rawValue)
            }
        }

        var rawValue: String {
            switch self {
            case .dismiss:
                return "DISMISS"
            case .openInAppStore:
                return "OPEN_IN_APP_STORE"
            case let .unknown(value):
                return value
            }
        }
    }

    let actionType: ActionType
    let title: String
}
