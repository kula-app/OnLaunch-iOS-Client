import Foundation

/// Structure of a message to be displayed to the user
internal struct Message: Identifiable {

    /// Unique identifier of this message.
    ///
    /// This identifier is used to track if the message has already been presented to the user
    internal let id: Int

    /// Title of the message
    internal let title: String

    /// Content of the message
    internal let body: String

    /// Flag indicating if this message is blocking the user
    internal let isBlocking: Bool

    /// Actions for the user to interact with
    internal let actions: [Action]
}
