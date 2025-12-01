//
//  File.swift
//  composable-message-composer
//
//  Created by Ratnesh Jain on 20/06/25.
//

import Dependencies
import DependenciesMacros
import Foundation
#if canImport(UIKit)
import MessageUI
#endif
@_exported import MessageModels
#if canImport(AppKit)
import AppKit
#endif

@DependencyClient
public struct MailComposerClient: Sendable {
    public var canSendMail: @Sendable @MainActor () -> Bool = { false }
    public var composeEmail: @Sendable (_ info: MailComposerInfo) async -> Void
}

extension MailComposerClient: DependencyKey {
    public static let liveValue: MailComposerClient = .init {
        #if canImport(UIKit)
        MFMailComposeViewController.canSendMail()
        #else
        let service = NSSharingService(named: NSSharingService.Name.composeEmail)
        return service != nil
        #endif
    } composeEmail: { info in
        #if canImport(AppKit)
        await MainActor.run {
            guard let service = NSSharingService(named: NSSharingService.Name.composeEmail) else {
                reportIssue("Email Composition service not available")
                return
            }
            
            service.recipients = info.recipients
            service.subject = info.subject
            var items: [Any] = [info.message]
            items.append(contentsOf: info.attachments.map { $0.data })
            
            if service.canPerform(withItems: items) {
                service.perform(withItems: items)
            } else {
                reportIssue("Sharing service cannot perform with provided items")
            }
        }
        #else
        reportIssue("Only available for AppKit")
        #endif
    }
}

extension DependencyValues {
    public var mailComposer: MailComposerClient {
        get { self[MailComposerClient.self] }
        set { self[MailComposerClient.self] = newValue }
    }
}
