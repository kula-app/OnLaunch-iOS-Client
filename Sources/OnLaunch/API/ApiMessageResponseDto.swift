import Foundation

internal struct ApiMessageResponseDto: Decodable {

    internal struct Action: Decodable {

        internal enum ActionType: String, Decodable {
            case button = "BUTTON"
            case dismissButton = "DISMISS"
        }

        internal let actionType: ActionType
        internal let title: String

    }

    internal let id: Int
    internal let blocking: Bool
    internal let title: String
    internal let body: String
    internal let actions: [Action]

}
