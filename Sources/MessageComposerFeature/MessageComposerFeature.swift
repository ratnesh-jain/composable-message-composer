//
//  File.swift
//  composable-message-composer
//
//  Created by Ratnesh Jain on 20/06/25.
//

import ComposableArchitecture
import Foundation
import MessageModels

@Reducer
public struct MessageComposerFeature: Sendable {
    @ObservableState
    public struct State: Equatable {
        var recipients: [String]?
        var subject: String?
        var body: String?
        var attachments: [Attachment]
        
        public init(info: MailComposerInfo) {
            self.recipients = info.recipients
            self.subject = info.subject
            self.body = info.message
            self.attachments = info.attachments
        }
        
        public init(recipients: [String]? = nil, subject: String? = nil, body: String? = nil, attachments: [Attachment] = []) {
            self.recipients = recipients
            self.subject = subject
            self.body = body
            self.attachments = attachments
        }
    }
    
    public enum Action: Equatable {
        public enum UserAction: Equatable {
            case dismissButtonTapped
        }
        
        case user(UserAction)
    }
    
    @Dependency(\.dismiss) private var dismiss
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .user(.dismissButtonTapped):
                return .run { send in
                    await dismiss()
                }
            }
        }
    }
}
