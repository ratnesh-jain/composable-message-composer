//
//  File.swift
//  composable-message-composer
//
//  Created by Ratnesh Jain on 20/06/25.
//

import Dependencies
import DependenciesMacros
import Foundation
@_exported import MessageModels
#if canImport(UIKit)
import MessageUI
#endif
#if canImport(AppKit)
import AppKit
#endif

@DependencyClient
public struct MessageComposerClient: Sendable {
    public var canSendMessage: @Sendable @MainActor () -> Bool = { false }
    public var composeMessage: @Sendable @MainActor (_ info: MailComposerInfo) async -> Void
}

extension MessageComposerClient: DependencyKey {
    public static let liveValue: MessageComposerClient = .init {
        #if canImport(UIKit)
        MFMessageComposeViewController.canSendText()
        #else
        let service = NSSharingService(named: NSSharingService.Name.composeMessage)
        return service != nil
        #endif
    } composeMessage: { info in
        #if canImport(AppKit)
        await MainActor.run {
            guard let service = NSSharingService(named: NSSharingService.Name.composeMessage) else {
                reportIssue("Message Composition service not available")
                return
            }
            service.recipients = info.recipients
            service.subject = info.subject
            
            var items: [Any] = [info.message]
            items.append(contentsOf: info.attachments.map { $0.data })
            if service.canPerform(withItems: items) {
                service.perform(withItems: items)
            } else {
                reportIssue("Sharing service can not perform with provided items")
            }
        }
        #else
        reportIssue("Only available for AppKit")
        #endif
    }
}

extension DependencyValues {
    public var messageComposer: MessageComposerClient {
        get { self[MessageComposerClient.self] }
        set { self[MessageComposerClient.self] = newValue }
    }
}
