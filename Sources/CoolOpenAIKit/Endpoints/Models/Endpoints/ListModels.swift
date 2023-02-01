//
//  ListModels.swift
//  CoolOpenAIKit
//
//  Created by chris on 1/25/23.
//

import Foundation

/// List all currently available models, and provides basic information about each one such as the owner and availability.
///
/// [https://beta.openai.com/docs/api-reference/models](https://beta.openai.com/docs/api-reference/models)
public struct ListModels: Endpoint {
    
    /// Endpoint
    public typealias Response = ResponseType
    
    public var path: String { "/v1/models" }
    public var method: HTTPMethod { .GET }
    
}

extension ListModels {
    
    public struct ResponseType: HTTPClient.Response {
        let object: String
        let data: [Model]
        
        /// Convenience getter for `data`
        var models: [Model] {
            data
        }
        
        // MARK: CustomStringConvertible
        
        public var description: String {
            models.description
        }
    }
    
}
