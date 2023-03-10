//
//  Prompt.swift
//  CoolOpenAIKit
//
//  Created by chris on 1/19/23.
//

import Foundation

extension Completions {
    
    public enum Prompt: CustomStringConvertible {
        case basic(prompt: String)
        case chatbot(message: String, botPrompt: String, conversation: [RawMessage])
        
        public var string: String {
            switch self {
            case let .basic(prompt):
                return prompt
            case let .chatbot(message, botPrompt, conversation):
                return [
                    // How the AI should act
                    botPrompt,
                    // Q/A formatted conversation history for AI's context
                    Chatbot.entries(from: conversation),
                    // Most recent send from user
                    Chatbot.question(message),
                    // Empty answer to prompt AI to respond like a chatbot
                    Chatbot.answer("")
                ].joined(separator: "\n")
            }
        }
        
        public var description: String {
            switch self {
            case .basic:
                return "Prompt.basic(\"\(self.string)\")"
            case .chatbot:
                return "Prompt.chatbot(\"\(self.string)\")"
            }
        }
    }
    
}

extension Completions.Prompt {
    
    public enum Chatbot: String {
        case support = "You are a friendly support person. The customer will ask you questions, and you will provide polite responses"
        
        public static func entries(from messages: [RawMessage]) -> String {
            messages.map { entry(for: $0) }.joined(separator: "\n")
        }
        
        public static func question(_ question: String) -> String {
            "Q: " + question
        }
        
        public static func answer(_ answer: String) -> String {
            "A: " + answer
        }
        
        public static func entry(for message: RawMessage) -> String {
            let isBot = message.userId == User.chatbot.rawValue
            let prefix: (String) -> String = isBot ? answer : question
            
            switch message.data {
            case .text(let message):
                return prefix(message)
            case .url(let url):
                return prefix(url.absoluteString)
            case .image:
                return prefix("Sent an image")
            }
        }
    }
    
}

public struct RawMessage: Hashable {
    
    public enum Data: Hashable {
        case text(String)
        case url(URL)
        case image
    }
    
    public var id: UUID
    public var date: Date
    public var data: Data
    public var userId: Int
    public var status: MessageStatus = .sent
    
}

public enum User: Int {
    case chatbot
    case user
}

public enum MessageStatus: Hashable {
    case sent
    case received
    case read
}
