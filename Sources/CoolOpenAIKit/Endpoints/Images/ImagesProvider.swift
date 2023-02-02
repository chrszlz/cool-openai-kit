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
    public func create(prompt: String, n: Int? = nil, size: Image.Size? = nil, responseFormat: CreateImage.Request.Format? = nil, user: String? = nil) async throws -> [Image]? {
        let request = CreateImage.Request(prompt: prompt, n: n, size: size, responseFormat: responseFormat, user: user)
        return try await create(request: request)
    }
    
    public func create(request: CreateImage.Request) async throws -> [Image]? {
        let endpoint = CreateImage(request: request)
        return try await client.execute(endpoint)?.data
    }
    
    /// Creates an image given a prompt.
    ///
    /// - Parameters:
    ///     - completion: Receives an optional image
    public func create(request: CreateImage.Request, _ completion: @escaping @Sendable ([Image]?) -> ()) {
        let endpoint = CreateImage(request: request)
        client.execute(endpoint) { response in
            completion(response?.data)
        }
    }
    
}
