//
//  Client.swift
//  CoolOpenAIKit
//
//  Created by chris on 1/17/23.
//

import UIKit

extension Endpoint {
    var scheme: String { "https" }
    var host: String { "api.openai.com" }
    
    /// Defaults
    var header: [String : String]? { nil }
    var body: (Encodable & Sendable)? { nil }
}


struct OpenAI {
    
    actor Client {
        private let httpClient: HTTPClient
        private let configuration: Configuration
        
        private let encoder: JSONEncoder
        private let decoder: JSONDecoder
        
        /// Providers
        
        /// List and describe the various models available in the API. You can refer to the [Models](https://beta.openai.com/docs/models) documentation to understand what models are available and the differences between them.
        nonisolated public lazy var models = ModelsProvider(client: self)
        /// Given a prompt, the model will return one or more predicted completions, and can also return the probabilities of alternative tokens at each position.
        nonisolated public lazy var completions = CompletionsProvider(client: self)
        
        init(config: Configuration? = .init()) {
            guard let config = config else {
                fatalError("\(Self.self) missing client configuration")
            }
            self.configuration = config
            
            self.encoder = JSONEncoder()
            self.encoder.keyEncodingStrategy = .convertToSnakeCase
            
            self.decoder = JSONDecoder()
            self.decoder.keyDecodingStrategy = .convertFromSnakeCase
            self.decoder.dateDecodingStrategy = .millisecondsSince1970
            
            self.httpClient = HTTPClient(decoder: self.decoder)
        }
        
        func execute<T: HTTPClient.Response>(_ endpoint: any Endpoint<T>) async throws -> T? {
            guard let request = URLRequest(encoder, endpoint: endpoint, configuration: configuration) else {
                throw Error.invalidURL(endpoint)
            }
            return try await httpClient.execute(request: request, model: T.self)
        }
        
        nonisolated func execute<T: HTTPClient.Response>(_ endpoint: any Endpoint<T>, completion: @escaping @Sendable (T?) -> ()) {
            Task {
                do {
                    let response = try await execute(endpoint)
                    completion(response)
                } catch {
                    debugPrint(error)
                    completion(nil)
                }
            }
        }
        
    }
    
}

extension OpenAI {
    
    struct Configuration {
        let apiKey: String
        let organization: String?
        
        init(apiKey: String, organization: String? = nil) {
            self.apiKey = apiKey
            self.organization = organization
        }
        
        init?(apiKey: String? = nil, organization: String? = nil) {
            let key = apiKey ?? ProcessInfo.processInfo.environment["OPENAI_API_KEY"]
            let org = organization ?? ProcessInfo.processInfo.environment["OPENAI_ORGANIZATION"]
            guard let key = key else {
                debugPrint("\(Self.self) is missing an API key")
                return nil
            }
            self.init(apiKey: key, organization: org)
        }
    }
    
    enum Error<T>: Swift.Error {
        case invalidURL(any Endpoint<T>)
    }
    
}

extension URLRequest {
    
    init?<T>(_ encoder: JSONEncoder, endpoint: any Endpoint<T>, configuration: OpenAI.Configuration) {
        self.init(encoder, endpoint: endpoint, headers: [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(configuration.apiKey)",
            "OpenAI-Organization": configuration.organization
        ])
    }
    
}

protocol Provider {
    var client: OpenAI.Client { get }
    
    init(client: OpenAI.Client)
}

