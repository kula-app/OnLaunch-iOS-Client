/// Structure used to define an user-interactable action
internal struct Action {

    /// Different kinds of actions, used to implement different behaviour
    internal enum Kind {

        /// Action is implemented as a generic button with an associated action
        case button

        /// Action is represented as a button which dismisses the UI
        case dismissButton
    }

    /// Kind of the action
    internal let kind: Kind

    /// Title of the action used to display in the UI
    internal let title: String
}
