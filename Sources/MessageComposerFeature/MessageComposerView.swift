//
//  File.swift
//  composable-message-composer
//
//  Created by Ratnesh Jain on 20/06/25.
//

import ComposableArchitecture
import Foundation
import MessageUI
import SwiftUI

public struct MessageComposerView: UIViewControllerRepresentable {
    
    let store: StoreOf<MessageComposerFeature>
    
    public init(store: StoreOf<MessageComposerFeature>) {
        self.store = store
    }
    
    public func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let viewController = MFMessageComposeViewController()
        viewController.recipients = store.receipients
        viewController.subject = store.subject
        viewController.body = store.body
        viewController.messageComposeDelegate = context.coordinator
        if let attachment = store.attachment {
            viewController.addAttachmentData(attachment.data, typeIdentifier: attachment.mimeType, filename: attachment.fileName)
        }
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}
    
    @MainActor
    public class Coordinator: NSObject, @preconcurrency MFMessageComposeViewControllerDelegate {
        
        let store: StoreOf<MessageComposerFeature>
        
        public init(store: StoreOf<MessageComposerFeature>) {
            self.store = store
        }
        
        public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            store.send(.user(.dismissButtonTapped))
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(store: store)
    }
    
}
