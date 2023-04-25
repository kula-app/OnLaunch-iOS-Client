import Foundation
import os.log

internal class LocalStorage {

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .init(suiteName: "OnLaunch")!) {
        self.defaults = defaults
    }

    func markMessageAsPresented(id: Message.ID) {
        os_log("Marking message %i as presented", log: .onlaunch, type: .debug, id)
        var markedIds = readListOfMarkedMessages()
        markedIds.insert(id)
        updateListOfMarkedMessages(ids: markedIds)
    }

    func isMessageMarkedAsPresented(id: Message.ID) -> Bool {
        readListOfMarkedMessages().contains(id)
    }

    private func updateListOfMarkedMessages(ids: Set<Message.ID>) {
        defaults.set(ids.map { $0.description }, forKey: "message-ids")
        defaults.synchronize()
    }

    private func readListOfMarkedMessages() -> Set<Message.ID> {
        Set(defaults.stringArray(forKey: "message-ids")?.compactMap { id in
            Message.ID(id)
        } ?? [])
    }
}
