import SwiftUI

internal struct MessageView: View {

    // MARK: - Environment

    @Environment(\.theme) private var theme: Theme
    @Environment(\.dismiss) private var dismiss

    // MARK: - State

    internal let message: Message
    internal let completionHandler: () -> Void

    // MARK: - View Body

    internal var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Button(action: {
                    dismiss()
                    completionHandler()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .symbolRenderingMode(.palette)
                        .resizable()
                        .foregroundStyle(Color(uiColor: .systemGray), Color(uiColor: .systemGray5))
                        .frame(width: 30, height: 30)
                        .padding(7)
                })
                .opacity(message.isBlocking ? 0.0 : 1.0)
            }
            .padding(.leading, 12)
            .padding(.trailing, 5)
            VStack(alignment: .leading, spacing: 0) {
                Text(message.title)
                    .font(theme.title.font)
                    .foregroundColor(theme.title.color)
                    .multilineTextAlignment(.leading)
                ScrollView {
                    Text(message.body)
                        .font(theme.body.font)
                        .foregroundColor(theme.body.color)
                        .multilineTextAlignment(.leading)
                }
                .padding(.vertical, 20)
                VStack(spacing: 12) {
                    ForEach(Array(message.actions.enumerated()), id: \.0) { _, action in
                        Button(action: {
                            switch action.kind {
                            case .button:
                                dismiss()
                            case .dismissButton:
                                dismiss()
                            }
                            completionHandler()
                        }, label: {
                            Text(action.title)
                                .font(theme.action.font)
                                .frame(maxWidth: .infinity)
                                .frame(minHeight: 50)
                        })
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 12)
    }
}
