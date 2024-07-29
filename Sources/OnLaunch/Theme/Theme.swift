import SwiftUI

public struct Theme {
    public struct Title {
        /// Font used by the message title
        public var font: Font

        /// Text color of the message title
        public var color: Color
    }

    public struct Body {
        /// Font used by the message body
        public var font: Font

        /// Text color of the message body
        public var color: Color
    }

    public struct Action {
        /// Font used for the title of the action buttons
        public var font: Font
    }

    /// Theme configuration of the message title
    public var title: Title

    /// Theme configuration of the message body
    public var body: Body

    /// Theme configuration of the actions
    public var action: Action
}

public extension Theme {
    /// Default theme unless something different is configured
    static let standard = Theme(
        title: .init(
            font: Font.system(size: 34, weight: .bold),
            color: Color(UIColor.label)
        ),
        body: .init(
            font: Font.system(size: 19, weight: .medium),
            color: Color.gray
        ),
        action: .init(
            font: .system(size: 19, weight: .medium)
        )
    )
}
