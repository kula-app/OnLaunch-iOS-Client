import SwiftUI

final class ActivityViewControllerWrapper: UIViewController {
    var activityItems: Binding<[Any]>
    var applicationActivities: [UIActivity]?
    var onComplete: UIActivityViewController.CompletionWithItemsHandler?

    init(
        activityItems: Binding<[Any]>,
        applicationActivities: [UIActivity]? = nil,
        onComplete: UIActivityViewController.CompletionWithItemsHandler? = nil
    ) {
        self.activityItems = activityItems
        self.applicationActivities = applicationActivities
        self.onComplete = onComplete
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        updateState()
    }

    func updateState() {
        let isActivityPresented = presentedViewController != nil
        let shouldBePresented = !activityItems.wrappedValue.isEmpty
        guard isActivityPresented != shouldBePresented else {
            return
        }
        guard !isActivityPresented else {
            return
        }
        let controller = UIActivityViewController(
            activityItems: activityItems.wrappedValue,
            applicationActivities: applicationActivities
        )
        controller.popoverPresentationController?.sourceView = view
        controller.completionWithItemsHandler = { [weak self] activityType, success, items, error in
            self?.activityItems.wrappedValue = []
            self?.onComplete?(activityType, success, items, error)
        }
        present(controller, animated: true, completion: nil)
    }
}
