import Foundation
import OSLog

class DataMapper {
    static func mapMessageDtos(_ dtos: [ApiMessageDto]) -> [Message] {
        dtos.map { mapMessageDto($0) }
    }

    static func mapMessageDto(_ dto: ApiMessageDto) -> Message {
        Message(
            id: dto.id,
            title: dto.title,
            body: dto.body,
            isBlocking: dto.blocking,
            actions: dto.actions.compactMap { mapActionDto($0) }
        )
    }

    static func mapActionDto(_ dto: ApiActionDto) -> Action? {
        switch dto.actionType {
        case .dismiss:
            return mapDismissActionDto(dto)
        case .openInAppStore:
            return mapOpenInAppStoreActionDto(dto)
        case .link:
            return mapLinkActionDto(dto)
        case let .unknown(value):
            os_log("Unknown action type: %@", log: .onlaunch, type: .error, value)
            return nil
        }
    }

    static func mapDismissActionDto(_ dto: ApiActionDto) -> Action {
        Action(
            kind: .dismissButton,
            title: dto.title
        )
    }

    static func mapOpenInAppStoreActionDto(_ dto: ApiActionDto) -> Action {
        Action(
            kind: .openAppInAppStore,
            title: dto.title
        )
    }

    static func mapLinkActionDto(_ dto: ApiActionDto) -> Action? {
        guard let link = dto.link?.link else {
            assertionFailure("Action has type 'link' without link, skipping action")
            return nil
        }
        guard let url = URL(string: link) else {
            assertionFailure("Action has invalid link url: \(link)")
            return nil
        }
        let target: LinkAction.Target?
        switch dto.link?.target {
        case .inAppBrowser:
            target = .inAppBrowser
        case .shareSheet:
            target = .shareSheet
        case .systemBrowser:
            target = .systemBrowser
        case let .unknown(string):
            assertionFailure("Action link has invalid target: \(string)")
            target = nil
        case nil:
            target = nil
        }
        return Action(
            kind: .link(.init(
                url: url,
                target: target
            )),
            title: dto.title
        )
    }
}
