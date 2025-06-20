//
//  File.swift
//  composable-message-composer
//
//  Created by Ratnesh Jain on 20/06/25.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct MailComposerFeature: Sendable {
    @ObservableState
    public struct State: Equatable {
        var receipients: [String]?
        var subject: String
        var message: String
        var isMessageHTML: Bool
        
        public init(receipients: [String]? = nil, subject: String = "", message: String = "", isMessageHTML: Bool = false) {
            self.receipients = receipients
            self.subject = subject
            self.message = message
            self.isMessageHTML = isMessageHTML
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
