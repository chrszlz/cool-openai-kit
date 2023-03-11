//
//  CreateImage.swift
//  CoolOpenAIKit
//
//  Created by chris on 2/1/23.
//

import Foundation

// MARK: Request

extension ImagesProvider.Endpoints {
    
    /// Given a prompt and/or an input image, the model will generate a new image.
    ///
    /// Related guide: [Image generation](https://platform.openai.com/docs/guides/images)
    public struct CreateImage: Endpoint {

        /// Endpoint
        public typealias Response = CreateImage.ResponseType
        
        public var path: String { "/v1/images/generations" }
        public var method: HTTPMethod { .POST }
        
        /// Parameters
        
        public enum Format: String, Encodable, Sendable {
            case url = "url"
            case base64 = "b64_json"
        }
        
        public let prompt: String
        public let n: Int?
        public let size: String?
        public let responseFormat: String?
        public let user: String?
        
        /// Given a prompt and/or an input image, the model will generate a new image.
        ///
        /// - Parameters:
        ///   - prompt: A text description of the desired image(s). The maximum length is 1000 characters.
        ///   - n: Defaults to 1. The number of images to generate. Must be between 1 and 10.
        ///   - size: Defaults to `1024x1024`. The size of the generated images. Must be one of `256x256`, `512x512`, or `1024x1024`.
        ///   - responseFormat: Defaults to `url`. The format in which the generated images are returned. Must be one of `url` or `b64_json`.
        ///   - user: A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse. [Learn more](https://platform.openai.com/docs/guides/safety-best-practices/end-user-ids).
        public init(prompt: String, n: Int? = nil, size: Image.Size? = nil, responseFormat: Format? = nil, user: String? = nil) {
            self.prompt = prompt
            self.n = n
            self.size = size?.rawValue
            self.responseFormat = responseFormat?.rawValue
            self.user = user
        }
        
    }
    
}

// MARK: Response

extension ImagesProvider.Endpoints.CreateImage {
    
    public struct ResponseType: HTTPClient.Response {
        public let created: Date
        public let data: [Image]
    }
    
}
