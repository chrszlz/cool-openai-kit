//
//  ModelsProvider.swift
//  CoolOpenAIKit
//
//  Created by chris on 1/25/23.
//

import Foundation

/// List and describe the various models available in the API. You can refer to the [Models](https://beta.openai.com/docs/models) documentation to understand what models are available and the differences between them.
struct ModelsProvider: Provider {
    
    let client: OpenAI.Client

    // MARK: List Models - /v1/models
    
    /// Retruns a list of currently available models, and provides basic information about each one such as the owner and availability.
    ///
    /// [https://beta.openai.com/docs/api-reference/models](https://beta.openai.com/docs/api-reference/models)
    func list() async throws -> [Model]? {
        let endpoint = ListModels()
        let response = try await client.execute(endpoint)
        return response?.data
    }
    
    /// Lists the currently available models, and provides basic information about each one such as the owner and availability.
    ///
    /// [https://beta.openai.com/docs/api-reference/models](https://beta.openai.com/docs/api-reference/models)
    ///
    /// - Parameters:
    ///     - completion: Receives an optional list of models
    func list(completion: @escaping @Sendable ([Model]?) -> ()) {
        let endpoint = ListModels()
        client.execute(endpoint) { response in
            completion(response?.data)
        }
    }

    // MARK: Retrieve Model - "/v1/models/\(model)"
    
    /// Returns a specified model instance, providing basic information about the model such as the owner and permissioning.
    ///
    /// [https://beta.openai.com/docs/api-reference/models/retrieve](https://beta.openai.com/docs/api-reference/models/retrieve)
    func retrieve(model: String) async throws -> Model? {
        let endpoint = RetrieveModel(model: model)
        let response = try await client.execute(endpoint)
        return response
    }
    
    /// Retrieves a model instance, providing basic information about the model such as the owner and permissioning.
    ///
    /// [https://beta.openai.com/docs/api-reference/models/retrieve](https://beta.openai.com/docs/api-reference/models/retrieve)
    ///
    /// - Parameters:
    ///     - completion: Receives an optional model
    func retrieve(model: String, completion: @escaping @Sendable (Model?) -> ()) {
        let endpoint = RetrieveModel(model: model)
        client.execute(endpoint, completion: completion)
    }
    
}
