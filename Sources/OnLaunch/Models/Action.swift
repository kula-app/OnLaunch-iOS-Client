/// Structure used to define an user-interactable action
struct Action {
    /// Different kinds of actions, used to implement different behaviour
    enum Kind {
        /// Action is represented as a button which dismisses the UI
        case dismissButton

        /// Action is dedicated to open the current app's App Store Page
        case openAppInAppStore

        /// Triggering the action should open the link in the 
        case link(LinkAction)
    }

    /// Kind of the action
    let kind: Kind

    /// Title of the action used to display in the UI
    let title: String
}
