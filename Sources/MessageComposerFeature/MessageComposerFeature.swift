//
//  File.swift
//  composable-message-composer
//
//  Created by Ratnesh Jain on 20/06/25.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct MessageComposerFeature: Sendable {
    @ObservableState
    public struct State: Equatable {
        var receipients: [String]?
        var subject: String?
        var body: String?
        
        public init(receipients: [String]? = nil, subject: String? = nil, body: String? = nil) {
            self.receipients = receipients
            self.subject = subject
            self.body = body
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
