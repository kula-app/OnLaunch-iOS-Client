import SwiftUI

struct MessageActionView: View {
    // MARK: - Environment

    @Environment(\.theme) private var theme: Theme

    // MARK: - State

    let action: Action

    // MARK: - Actions

    var dismiss: () -> Void = {}
    var openAppInAppStore: () -> Void = {}
    var openLink: (LinkAction) -> Void = { _ in }

    // MARK: - Initializer

    init(action: Action) {
        self.action = action
    }

    // MARK: - Content

    var body: some View {
        FilledButton(title: action.title) {
            switch action.kind {
            case .dismissButton:
                dismiss()
            case .openAppInAppStore:
                openAppInAppStore()
            case let .link(linkAction):
                openLink(linkAction)
            }
        }
    }
}

// MARK: - Action Modifiers

extension MessageActionView {
    func dismissAction(_ action: @escaping () -> Void) -> Self {
        var view = self
        view.dismiss = action
        return view
    }

    func openAppInAppStoreAction(_ action: @escaping () -> Void) -> Self {
        var view = self
        view.openAppInAppStore = action
        return view
    }

    func openLinkAction(_ action: @escaping (LinkAction) -> Void) -> Self {
        var view = self
        view.openLink = action
        return view
    }
}
