//
//  CompletionsProvider.swift
//  CoolOpenAIKit
//
//  Created by chris on 1/25/23.
//

import Foundation

/// Given a prompt, the model will return one or more predicted completions, and can also return the probabilities of alternative tokens at each position.
public struct CompletionsProvider: Provider {
    
    public let client: OpenAI.Client!
    
    // MARK: Create completion - /v1/completions
    
    /// Creates a completion for the provided prompt and request, returning a list of completion choices.
    ///
    /// [https://beta.openai.com/docs/api-reference/completions/create](https://beta.openai.com/docs/api-reference/completions/create)
    ///
    /// - Parameters:
    ///     - request: Given prompt and parameters for the request
    func create(_ request: Completions.Request) async throws -> [Completions.Choice]? {
        let endpoint = Completions(request: request)
        return try await client.execute(endpoint)?.choices
    }
    
    /// Creates a completion for the provided prompt and request, returning a list of completion choices.
    ///
    /// [https://beta.openai.com/docs/api-reference/completions/create](https://beta.openai.com/docs/api-reference/completions/create)
    ///
    /// - Parameters:
    ///     - request: Given prompt and parameters for the request
    ///     - completion: Receives an optional list of choices
    func create(_ request: Completions.Request, completion: @escaping @Sendable ([Completions.Choice]?) -> ()) {
        let endpoint = Completions(request: request)
        client.execute(endpoint) { response in
            completion(response?.choices)
        }
    }
    
    /// Creates a completion for the provided prompt and request, returning a list of completion choices.
    ///
    /// [https://beta.openai.com/docs/api-reference/completions/create](https://beta.openai.com/docs/api-reference/completions/create)
    ///
    /// - Parameters:
    ///     (chuckles nervously)
    func create(_ model: Completions.Model, prompt: Completions.Prompt?, suffix: String? = nil, maxTokens: Int? = nil, temperature: Double? = nil, topP: Double? = nil, n: Int? = nil, stream: Bool? = nil, logprobs: Int? = nil, echo: Bool? = nil, stop: [String]? = nil, presencePenalty: Double? = nil, frequencyPenalty: Double? = nil, bestOf: Int? = nil, logitBias: [String : Int]? = nil, user: String? = nil) async throws -> [Completions.Choice]? {
        let prompt: String? = prompt?.string
        let request = Completions.Request(model: model, prompt: prompt, suffix: suffix, maxTokens: maxTokens, temperature: temperature, topP: topP, n: n, stream: stream, logprobs: logprobs, echo: echo, stop: stop, presencePenalty: presencePenalty, frequencyPenalty: frequencyPenalty, bestOf: bestOf, logitBias: logitBias, user: user)
        return try await create(request)
    }
    
}
