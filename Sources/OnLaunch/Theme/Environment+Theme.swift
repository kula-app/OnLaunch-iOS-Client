import SwiftUI

private struct ThemeEnvironmentKey: EnvironmentKey {
    fileprivate static let defaultValue = Theme.standard
}

extension EnvironmentValues {

    internal var theme: Theme {
        get {
            self[ThemeEnvironmentKey.self]
        }
        set {
            self[ThemeEnvironmentKey.self] = newValue
        }
    }
}
