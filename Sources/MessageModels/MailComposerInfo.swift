//
//  MailComposerInfo.swift
//  composable-message-composer
//
//  Created by Ratnesh Jain on 30/11/25.
//

import Foundation

public struct MailComposerInfo: Equatable, Sendable {
    public var recipients: [String]?
    public var subject: String
    public var message: String
    public var isMessageHTML: Bool
    public var attachments: [Attachment]
    
    public init(recipients: [String]? = nil, subject: String, message: String, isMessageHTML: Bool, attachments: [Attachment]) {
        self.recipients = recipients
        self.subject = subject
        self.message = message
        self.isMessageHTML = isMessageHTML
        self.attachments = attachments
    }
}
