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
struct RetrieveModel: Endpoint {

    typealias Response = Model
    
    var path: String { "/v1/models/\(model)" }
    var method: HTTPMethod { .GET }
    
    let model: String
    
}
