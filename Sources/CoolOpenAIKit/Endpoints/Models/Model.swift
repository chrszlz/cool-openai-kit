//
//  Model.swift
//  CoolOpenAIKit
//
//  Created by chris on 1/25/23.
//

import Foundation

struct Model: HTTPClient.Response {
    
    let id: String
    let object: String
    let ownedBy: String
    let permissions: [Permission]?
    
    /// Convenience getter for `id`
    var name: String {
        id
    }
    
    // MARK: CustomStringConvertible
    
    public var description: String {
        "\(object): \(name)"
    }
    
}

extension Model {
    
    struct Permission: HTTPClient.Response {
        let id: String
        let object: String
        let created: Date
        let allowCreateEngine: Bool
        let allowSampling: Bool
        let allowLogprobs: Bool
        let allowSearchIndices: Bool
        let allowView: Bool
        let allowFineTuning: Bool
        let organization: String
        let group: String?
        let isBlocking: Bool
    }
    
}
