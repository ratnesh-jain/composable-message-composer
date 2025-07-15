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

public struct MailComposerView: UIViewControllerRepresentable {
    let store: StoreOf<MailComposerFeature>
    
    public init(store: StoreOf<MailComposerFeature>) {
        self.store = store
    }
    
    public func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = context.coordinator
        viewController.setToRecipients(store.receipients)
        viewController.setSubject(store.subject)
        viewController.setMessageBody(store.message, isHTML: store.isMessageHTML)
        if let attachment = store.attachment {
            viewController.addAttachmentData(attachment.data, mimeType: attachment.mimeType, fileName: attachment.fileName)
        }
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    @MainActor
    public class Coordinator: NSObject, @preconcurrency MFMailComposeViewControllerDelegate {
        let store: StoreOf<MailComposerFeature>
        
        init(store: StoreOf<MailComposerFeature>) {
            self.store = store
        }
        
        public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: (any Error)?) {
            store.send(.user(.dismissButtonTapped))
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(store: self.store)
    }
}
