import SafariServices
import SwiftUI

struct SafariView: View {
    let url: URL

    var body: some View {
        _SafariView(url: url)
            .ignoresSafeArea(.container)
    }
}

// swiftlint:disable:next type_name
struct _SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // noop
    }
}
