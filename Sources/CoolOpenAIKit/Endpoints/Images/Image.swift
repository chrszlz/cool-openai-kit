//
//  Image.swift
//  CoolOpenAIKit
//
//  Created by chris on 2/1/23.
//

import UIKit
import ToolKit

public enum Image: HTTPClient.Response {
    case url(url: String)
    case base64(data: Data)
}

extension Image {
    
    public enum Size: String, Encodable, Sendable {
        case res256 = "256x256"
        case res512 = "512x512"
        case res1024 = "1024x1024"
    }
    
}

extension Image {
    
    public var uiImage: UIImage? {
        get async throws {
            switch self {
            case .url(let url):
                return try await ImageDownloader.download(imageUrl: url)
            case .base64(let data):
                return UIImage(data: data)
            }
        }
    }
    
}
