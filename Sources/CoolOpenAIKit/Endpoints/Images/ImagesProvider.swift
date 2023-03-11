//
//  ImagesProvider.swift
//  CoolOpenAIKit
//
//  Created by chris on 2/1/23.
//

import Foundation

/// Given a prompt and/or an input image, the model will generate a new image.
///
/// Related guide: [Image generation](https://platform.openai.com/docs/guides/images)
public struct ImagesProvider: Provider {
    
    public let client: OpenAI.Client!
    
    // MARK: Create Image - /v1/images/generations
    
    /// Creates an image given a prompt.
    public func create(prompt: String, n: Int? = nil, size: Image.Size? = nil, responseFormat: Endpoints.CreateImage.Format? = nil, user: String? = nil) async throws -> [Image]? {
        let endpoint = Endpoints.CreateImage(prompt: prompt, n: n, size: size, responseFormat: responseFormat, user: user)
        print("Request: ", endpoint)
        return try await client.execute(endpoint)?.data
    }
    
    /// Creates an image given a prompt.
    ///
    /// - Parameters:
    ///     - completion: Receives an optional image
    public func create(_ endpoint: Endpoints.CreateImage, _ completion: @escaping @Sendable ([Image]?) -> ()) {
        client.execute(endpoint) { response in
            completion(response?.data)
        }
    }
    
}

extension ImagesProvider {
    
    public enum Endpoints { }
    
}
