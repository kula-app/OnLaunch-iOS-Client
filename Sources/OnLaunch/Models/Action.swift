/// Structure used to define an user-interactable action
struct Action {
    /// Different kinds of actions, used to implement different behaviour
    enum Kind {
        /// Action is implemented as a generic button with an associated action
        case button

        /// Action is represented as a button which dismisses the UI
        case dismissButton

        /// Action is dedicated to open the current app's App Store Page
        case openAppInAppStore
    }

    /// Kind of the action
    let kind: Kind

    /// Title of the action used to display in the UI
    let title: String
}
