import Foundation
import SwiftUI

struct ActivityView: UIViewControllerRepresentable {
    private let applicationActivities: [UIActivity]?
    private let onComplete: UIActivityViewController.CompletionWithItemsHandler?

    @Binding fileprivate var activityItems: [Any]

    init(
        items: Binding<[Any]>,
        activities: [UIActivity]? = nil,
        onComplete: UIActivityViewController.CompletionWithItemsHandler? = nil
    ) {
        _activityItems = items
        self.applicationActivities = activities
        self.onComplete = onComplete
    }

    func makeUIViewController(context _: Context) -> ActivityViewControllerWrapper {
        ActivityViewControllerWrapper(
            activityItems: $activityItems,
            applicationActivities: applicationActivities,
            onComplete: onComplete
        )
    }

    func updateUIViewController(_ uiViewController: ActivityViewControllerWrapper, context _: Context) {
        uiViewController.activityItems = $activityItems
        uiViewController.onComplete = onComplete
        uiViewController.updateState()
    }
}

public extension View {
    func shareSheet(
        items: Binding<[Any]>,
        applicationActivities: [UIActivity]? = nil,
        onComplete: UIActivityViewController.CompletionWithItemsHandler? = nil
    ) -> some View {
        background(ActivityView(
            items: items,
            activities: applicationActivities,
            onComplete: onComplete
        ))
    }

    func shareSheet(
        isPresented: Binding<Bool>,
        items: [Any],
        applicationActivities: [UIActivity]? = nil,
        onComplete: UIActivityViewController.CompletionWithItemsHandler? = nil
    ) -> some View {
        background(ActivityView(
            items: .init(get: {
                isPresented.wrappedValue ? items : []
            }, set: { value in
                isPresented.wrappedValue = !value.isEmpty
            }),
            activities: applicationActivities,
            onComplete: onComplete
        ))
    }
}
