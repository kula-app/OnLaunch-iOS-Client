import SwiftUI

struct FilledButton: View {
    @Environment(\.theme) private var theme: Theme

    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action, label: {
            Text(title)
                .font(theme.action.font)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 50)
        })
        .buttonStyle(.borderedProminent)
    }
}
