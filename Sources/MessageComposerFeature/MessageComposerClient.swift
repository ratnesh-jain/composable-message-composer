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
public struct MessageComposerClient: Sendable {
    public var canSendMail: @Sendable @MainActor () -> Bool = { false }
}

extension MessageComposerClient: DependencyKey {
    public static let liveValue: MessageComposerClient = .init {
        MFMessageComposeViewController.canSendText()
    }
}

extension DependencyValues {
    public var messageComposer: MessageComposerClient {
        get { self[MessageComposerClient.self] }
        set { self[MessageComposerClient.self] = newValue }
    }
}
