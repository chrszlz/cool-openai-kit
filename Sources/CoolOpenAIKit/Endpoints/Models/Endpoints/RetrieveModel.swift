//
//  RetrieveModel.swift
//  CoolOpenAIKit
//
//  Created by chris on 1/25/23.
//

import Foundation

/// Retrieve a specified model instance, providing basic information about the model such as the owner and permissioning.
///
/// [https://beta.openai.com/docs/api-reference/models/retrieve](https://beta.openai.com/docs/api-reference/models/retrieve)
public struct RetrieveModel: Endpoint {

    /// Endpoint
    public typealias Response = Model
    
    public var path: String { "/v1/models/\(model)" }
    public var method: HTTPMethod { .GET }
    
    /// Parameters
    public let model: String
    
}
