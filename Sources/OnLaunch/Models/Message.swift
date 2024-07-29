import Foundation

/// Structure of a message to be displayed to the user
struct Message: Identifiable {
    /// Unique identifier of this message.
    ///
    /// This identifier is used to track if the message has already been presented to the user
    let id: Int

    /// Title of the message
    let title: String

    /// Content of the message
    let body: String

    /// Flag indicating if this message is blocking the user
    let isBlocking: Bool

    /// Actions for the user to interact with
    let actions: [Action]
}
