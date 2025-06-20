//
//  File.swift
//  composable-message-composer
//
//  Created by Ratnesh Jain on 20/06/25.
//

import Dependencies
import DependenciesMacros
import Foundation
import MessageUI

@DependencyClient
public struct MailComposerClient: Sendable {
    public var canSendMail: @Sendable @MainActor () -> Bool = { false }
}

extension MailComposerClient: DependencyKey {
    public static let liveValue: MailComposerClient = .init {
        MFMailComposeViewController.canSendMail()
    }
}

extension DependencyValues {
    public var mailComposer: MailComposerClient {
        get { self[MailComposerClient.self] }
        set { self[MailComposerClient.self] = newValue }
    }
}
