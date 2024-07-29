import SwiftUI

struct MessageActionView: View {
    @Environment(\.theme) private var theme: Theme

    let action: Action
    let dismiss: () -> Void
    let openAppInAppStore: () -> Void

    init(action: Action, dismiss: @escaping () -> Void, openAppInAppStore: @escaping () -> Void) {
        self.action = action
        self.dismiss = dismiss
        self.openAppInAppStore = openAppInAppStore
    }

    @ViewBuilder
    var body: some View {
        switch action.kind {
        case .dismissButton:
            dismissButtonView
        case .openAppInAppStore:
            openAppInAppStoreButtonView
        }
    }

    var dismissButtonView: some View {
        Button(action: {
            dismiss()
        }, label: {
            Text(action.title)
                .font(theme.action.font)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 50)
        })
        .buttonStyle(.borderedProminent)
    }

    var openAppInAppStoreButtonView: some View {
        Button(action: {
            openAppInAppStore()
        }, label: {
            Text(action.title)
                .font(theme.action.font)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 50)
        })
        .buttonStyle(.borderedProminent)
    }
}
