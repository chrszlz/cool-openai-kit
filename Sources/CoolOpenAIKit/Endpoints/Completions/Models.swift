//
//  Models.swift
//  CoolOpenAIKit
//
//  Created by chris on 1/25/23.
//

import Foundation

extension Completions {
    
    public enum Model: String, Codable, Sendable {
        case davinci = "text-davinci-003"
        case curie = "text-curie-001"
        case babbage = "text-babbage-001"
        case ada = "text-ada-001"
    }
    
}
