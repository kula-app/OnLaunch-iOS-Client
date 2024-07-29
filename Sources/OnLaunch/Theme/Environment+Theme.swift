import SwiftUI

private struct ThemeEnvironmentKey: EnvironmentKey {
    fileprivate static let defaultValue = Theme.standard
}

extension EnvironmentValues {
    var theme: Theme {
        get {
            self[ThemeEnvironmentKey.self]
        }
        set {
            self[ThemeEnvironmentKey.self] = newValue
        }
    }
}
