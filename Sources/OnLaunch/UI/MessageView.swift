import SwiftUI

struct MessageView: View {
    // MARK: - Environment

    @Environment(\.theme) private var theme: Theme
    @Environment(\.dismiss) private var dismiss

    // MARK: - State

    let message: Message
    let options: OnLaunch.Options
    let completionHandler: () -> Void

    // MARK: - View Body

    var body: some View {
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
                actionsView
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 12)
    }

    var actionsView: some View {
        VStack(spacing: 12) {
            ForEach(Array(message.actions.enumerated()), id: \.0) { _, action in
                MessageActionView(
                    action: action,
                    dismiss: {
                        dismiss()
                        completionHandler()
                    },
                    openAppInAppStore: {
                        guard let appStoreId = options.appStoreId,
                              let url = URL(string: "https://apps.apple.com/app/id\(appStoreId)") else {
                            return assertionFailure("Failed to create App Store store page url")
                        }
                        UIApplication.shared.open(url) { success in
                            if !success {
                                assertionFailure("Failed to open URL: \(url)")
                            }
                        }
                    }
                )
            }
        }
    }
}
