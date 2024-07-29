struct ApiActionDto: Decodable {
    enum ActionType: String, Decodable {
        case button = "BUTTON"
        case dismissButton = "DISMISS"
        case openInAppStore = "OPEN_IN_APP_STORE"
    }

    let actionType: ActionType
    let title: String
}
