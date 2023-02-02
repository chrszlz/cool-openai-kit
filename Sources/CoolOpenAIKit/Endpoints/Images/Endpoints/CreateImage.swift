//
//  CreateImage.swift
//  CoolOpenAIKit
//
//  Created by chris on 2/1/23.
//

import Foundation

/// Given a prompt and/or an input image, the model will generate a new image.
///
/// Related guide: [Image generation](https://platform.openai.com/docs/guides/images)
public struct CreateImage: Endpoint {
    
    /// Endpoint
    public typealias Response = CreateImage.ResponseType
    
    public var path: String { "/v1/images/generations" }
    public var method: HTTPMethod { .POST }
    
    /// Parameters
    
    /// A text description of the desired image(s). The maximum length is 1000 characters.
    public let prompt: String
    /// Defaults to 1. The number of images to generate. Must be between 1 and 10.
    public let n: Int?
    /// Defaults to `1024x1024`. The size of the generated images. Must be one of `256x256`, `512x512`, or `1024x1024`.
    public let size: String?
    /// Defaults to `url`. The format in which the generated images are returned. Must be one of `url` or `b64_json`.
    public let responseFormat: String?
    /// A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse. [Learn more](https://platform.openai.com/docs/guides/safety-best-practices/end-user-ids).
    public let user: String?
    
    public init(prompt: String, n: Int? = nil, size: Image.Size? = nil, responseFormat: Request.Format? = nil, user: String? = nil) {
        self.prompt = prompt
        self.n = n
        self.size = size?.rawValue
        self.responseFormat = responseFormat?.rawValue
        self.user = user
    }
    
    public init(request: CreateImage.Request) {
        self.init(
            prompt: request.prompt,
            n: request.n,
            size: request.size,
            responseFormat: request.responseFormat,
            user: request.user
        )
    }
    
}

// MARK: Request

extension CreateImage {
    
    public struct Request: Encodable, Sendable {
        public enum Format: String, Encodable, Sendable {
            case url = "url"
            case base64 = "b64_json"
        }
        
        /// A text description of the desired image(s). The maximum length is 1000 characters.
        public let prompt: String
        /// Defaults to 1. The number of images to generate. Must be between 1 and 10.
        public let n: Int?
        /// Defaults to `1024x1024`. The size of the generated images. Must be one of `256x256`, `512x512`, or `1024x1024`.
        public let size: Image.Size?
        /// Defaults to `url`. The format in which the generated images are returned. Must be one of `url` or `b64_json`.
        public let responseFormat: Format?
        /// A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse. [Learn more](https://platform.openai.com/docs/guides/safety-best-practices/end-user-ids).
        public let user: String?
    }
    
}

// MARK: Response

extension CreateImage {
    
    public struct ResponseType: HTTPClient.Response {
        public let created: Date
        public let data: [Image]
    }
    
}
