//
//  File.swift
//  composable-message-composer
//
//  Created by Ratnesh Jain on 15/07/25.
//

import Foundation

public struct Attachment: Equatable, Sendable {
    public var data: Data
    public var mimeType: String
    public var fileName: String
    
    public init(data: Data, mimeType: String, fileName: String) {
        self.data = data
        self.mimeType = mimeType
        self.fileName = fileName
    }
}
