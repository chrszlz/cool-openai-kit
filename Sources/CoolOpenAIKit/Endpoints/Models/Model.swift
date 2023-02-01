//
//  Model.swift
//  CoolOpenAIKit
//
//  Created by chris on 1/25/23.
//

import Foundation

public struct Model: HTTPClient.Response {
    
    public let id: String
    public let object: String
    public let ownedBy: String
    public let permissions: [Permission]?
    
    /// Convenience getter for `id`
    public var name: String {
        id
    }
    
    // MARK: CustomStringConvertible
    
    public var description: String {
        "\(object): \(name)"
    }
    
}

extension Model {
    
    public struct Permission: HTTPClient.Response {
        public let id: String
        public let object: String
        public let created: Date
        public let allowCreateEngine: Bool
        public let allowSampling: Bool
        public let allowLogprobs: Bool
        public let allowSearchIndices: Bool
        public let allowView: Bool
        public let allowFineTuning: Bool
        public let organization: String
        public let group: String?
        public let isBlocking: Bool
    }
    
}
