//
//  Completions.swift
//  CoolOpenAIKit
//
//  Created by chris on 1/25/23.
//

import Foundation

/// Given a prompt, the model will return one or more predicted completions, and can also return the probabilities of alternative tokens at each position.
public struct Completions: Endpoint {
    
    public typealias Response = Completions.ResponseType
    
    public var path: String { "/v1/completions" }
    public var method: HTTPMethod { .POST }
    public let body: (Encodable & Sendable)?
    
    public init(request: Request) {
        self.body = request
    }
    
}

// MARK: Request

extension Completions {
    
    public struct Request: Encodable, Sendable {
        /**
         ID of the model to use. You can use the [List models](https://beta.openai.com/docs/api-reference/models/list) API to see all of your available models, or see our [Model overview](https://beta.openai.com/docs/models/overview) for descriptions of them
         */
        let model: Completions.Model
        /**
         Defaults to `<|endoftext|>`
         
         The prompt(s) to generate completions for, encoded as a string, array of strings, array of tokens, or array of token arrays.
         
         Note that `<|endoftext|>` is the document separator that the model sees during training, so if a prompt is not specified the model will generate as if from the beginning of a new document.
         */
        let prompt: [String]?
        /**
         Defaults to `nil`
         
         The suffix that comes after a completion of inserted text.
         */
        let suffix: String?
        /**
         Defaults to `16`
         
         The maximum number of [tokens](https://beta.openai.com/tokenizer) to generate in the completion.
         
         The token count of your prompt plus `maxTokens` cannot exceed the model's context length. Most models have a context length of 2048 tokens (except for the newest models, which support 4096).
         */
        let maxTokens: Int?
        /**
         Defaults to `1`
         
         What [sampling temperature](https://towardsdatascience.com/how-to-sample-from-language-models-682bceb97277) to use. Higher values means the model will take more risks. Try 0.9 for more creative applications, and 0 (argmax sampling) for ones with a well-defined answer.
         
         We generally recommend altering this or `topP` but not both.
         */
        let temperature: Double?
        /**
         Defaults to `1`
         
         An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered.
         
         We generally recommend altering this or temperature but not both.
         */
        let topP: Double?
        /**
         Defaults to `1`
         
         How many completions to generate for each prompt.
         
         Note: Because this parameter generates many completions, it can quickly consume your token quota. Use carefully and ensure that you have reasonable settings for `maxTokens` and `stop`.
         */
        let n: Int?
        /**
         Defaults to `false`
         
         Whether to stream back partial progress. If set, tokens will be sent as data-only [server-sent events](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events#Event_stream_format) as they become available, with the stream terminated by a `data: [DONE]` message.
         */
        let stream: Bool?
        /**
         Defaults to `nil`
         
         Include the log probabilities on the `logprobs` most likely tokens, as well the chosen tokens. For example, if `logprobs` is `5`, the API will return a list of the 5 most likely tokens. The API will always return the `logprob` of the sampled token, so there may be up to `logprobs+1` elements in the response.
         
         The maximum value for `logprobs` is 5. If you need more than this, please contact us through our [Help center](https://help.openai.com/) and describe your use case.
         */
        let logprobs: Int?
        /**
         Defaults to `false`
         
         Echo back the prompt in addition to the completion
         */
        let echo: Bool?
        /**
         Defaults to `nil`
         
         Up to 4 sequences where the API will stop generating further tokens. The returned text will not contain the stop sequence.
         */
        let stop: [String]?
        /**
         Defaults to `0`
         
         Number between `-2.0` and `2.0`. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics.
         
         [See more information about frequency and presence penalties](https://beta.openai.com/docs/api-reference/parameter-details)
         */
        let presencePenalty: Double?
        /**
         Defaults to `0`
         
         Number between `-2.0` and `2.0`. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim.
         
         [See more information about frequency and presence penalties.](https://beta.openai.com/docs/api-reference/parameter-details)
         */
        let frequencyPenalty: Double?
        /**
         Defaults to `1`
         
         Generates `best_of` completions server-side and returns the "best" (the one with the highest log probability per token). Results cannot be streamed.
         
         When used with `n`, `bestOf` controls the number of candidate completions and `n` specifies how many to return – `bestOf` must be greater than `n`.
         
         Note: Because this parameter generates many completions, it can quickly consume your token quota. Use carefully and ensure that you have reasonable settings for `maxTokens` and `stop`.
         */
        let bestOf: Int?
        /**
         Defaults to `nil`
         Modify the likelihood of specified tokens appearing in the completion.
         
         Accepts a json object that maps tokens (specified by their token ID in the GPT tokenizer) to an associated bias value from -100 to 100. You can use this [tokenizer tool](https://beta.openai.com/tokenizer?view=bpe) (which works for both GPT-2 and GPT-3) to convert text to token IDs. Mathematically, the bias is added to the logits generated by the model prior to sampling. The exact effect will vary per model, but values between -1 and 1 should decrease or increase likelihood of selection; values like -100 or 100 should result in a ban or exclusive selection of the relevant token.
         
         As an example, you can pass `{"50256": -100}` to prevent the `<|endoftext|>` token from being generated.
         */
        let logitBias: [String: Int]?
        /**
         A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse. [Learn more.](https://beta.openai.com/docs/guides/safety-best-practices/end-user-ids)
         */
        let user: String?
        
        /// See `Request` for information about parameters
        init(model: Completions.Model, prompt: [String]?, suffix: String? = nil, maxTokens: Int? = nil, temperature: Double? = nil, topP: Double? = nil, n: Int? = nil, stream: Bool? = nil, logprobs: Int? = nil, echo: Bool? = nil, stop: [String]? = nil, presencePenalty: Double? = nil, frequencyPenalty: Double? = nil, bestOf: Int? = nil, logitBias: [String : Int]? = nil, user: String? = nil) {
            self.model = model
            self.prompt = prompt
            self.suffix = suffix
            self.maxTokens = maxTokens
            self.temperature = temperature
            self.topP = topP
            self.n = n
            self.stream = stream
            self.logprobs = logprobs
            self.echo = echo
            self.stop = stop
            self.presencePenalty = presencePenalty
            self.frequencyPenalty = frequencyPenalty
            self.bestOf = bestOf
            self.logitBias = logitBias
            self.user = user
        }
        
        /// See `Request` for information about parameters
        init(model: Completions.Model, prompt: String?, suffix: String? = nil, maxTokens: Int? = nil, temperature: Double? = nil, topP: Double? = nil, n: Int? = nil, stream: Bool? = nil, logprobs: Int? = nil, echo: Bool? = nil, stop: [String]? = nil, presencePenalty: Double? = nil, frequencyPenalty: Double? = nil, bestOf: Int? = nil, logitBias: [String : Int]? = nil, user: String? = nil) {
            let prompt: [String] = [prompt].compactMap { $0 }
            self.init(model: model, prompt: prompt, suffix: suffix, maxTokens: maxTokens, temperature: temperature, topP: topP, n: n, stream: stream, logprobs: logprobs, echo: echo, stop: stop, presencePenalty: presencePenalty, frequencyPenalty: frequencyPenalty, bestOf: bestOf, logitBias: logitBias, user: user)
        }
        
        /// See `Request` for information about parameters
        init(model: Completions.Model, prompt: Completions.Prompt?, suffix: String? = nil, maxTokens: Int? = nil, temperature: Double? = nil, topP: Double? = nil, n: Int? = nil, stream: Bool? = nil, logprobs: Int? = nil, echo: Bool? = nil, stop: [String]? = nil, presencePenalty: Double? = nil, frequencyPenalty: Double? = nil, bestOf: Int? = nil, logitBias: [String : Int]? = nil, user: String? = nil) {
            let prompt: String? = prompt?.string
            self.init(model: model, prompt: prompt, suffix: suffix, maxTokens: maxTokens, temperature: temperature, topP: topP, n: n, stream: stream, logprobs: logprobs, echo: echo, stop: stop, presencePenalty: presencePenalty, frequencyPenalty: frequencyPenalty, bestOf: bestOf, logitBias: logitBias, user: user)
        }
    }
    
}

// MARK: Response

extension Completions {
    
    public struct ResponseType: HTTPClient.Response {
        let id: String
        let object: String
        let created: Date
        let model: String
        let choices: [Completions.Choice]
        let usage: [String: Int]
        
        // MARK: CustomStringConvertible
        
        public var description: String {
            return "\(Self.self)\n\t- \(choices)"
        }
        
    }
    
    public struct Choice: HTTPClient.Response {
        let text: String
        let index: Int
        let logprobs: Int?
        let finishReason: String
        
        // MARK: CustomStringConvertible
        
        public var description: String {
            return "\(Self.self)(\"\(text)\")"
        }
    }
    
}
