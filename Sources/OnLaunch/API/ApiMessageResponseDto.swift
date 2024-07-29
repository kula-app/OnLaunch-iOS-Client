import Foundation

struct ApiMessageResponseDto: Decodable {
    struct Action: Decodable {
        enum ActionType: String, Decodable {
            case button = "BUTTON"
            case dismissButton = "DISMISS"
            case openInAppStore = "OPEN_IN_APP_STORE"
        }

        let actionType: ActionType
        let title: String
    }

    let id: Int
    let blocking: Bool
    let title: String
    let body: String
    let actions: [Action]
}
