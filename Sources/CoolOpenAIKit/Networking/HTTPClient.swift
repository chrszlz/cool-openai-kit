//
//  HTTPClient.swift
//  ToolKit
//
//  Created by chris on 1/14/23.
//

import Foundation

enum HTTPMethod: String, Sendable {
    case DELETE
    case GET
    case PATCH
    case POST
    case PUT
}

actor HTTPClient {
    
    typealias Response = Codable & Sendable
    
    public private(set) var activeTasks = [String: Task<Response?, Error>]()
    public private(set) var failedTasks = [String: Task<Response?, Error>]()
    
    private let session = URLSession.shared
    private let decoder: JSONDecoder
    
    init(decoder: JSONDecoder) {
        self.decoder = decoder
    }
    
    func execute<T: Response>(request: URLRequest, model type: T.Type) async throws -> T? {
        if let existingTask = activeTasks[request.id] {
            guard let value = try await existingTask.value as? T else {
                throw HTTPError.typeCastFailed(request: request, type: type, task: existingTask)
            }
            return value
        }
        
        let task = Task<Response?, Error> { [weak self, request] () throws -> T? in
            do {
                try Task.checkCancellation()
                
                // Extra credit: improve status handling
                let (data, response) = try await session.data(for: request, delegate: nil)
                guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                    await self?.removeActiveTask(id: request.id)
                    throw HTTPError.badResponse(request: request, response: response, type: type)
                }
                
                let model = try decoder.decode(type, from: data)
                // Remove completed task, only if decoding was successful
                await self?.removeActiveTask(id: request.id)
                return model
            } catch {
                // Remove from active tasks and move into Failed
                let task = await self?.removeActiveTask(id: request.id)
                await self?.addFailedTask(id: request.id, task)
                
                switch error {
                case let error as DecodingError:
                    throw HTTPError.failedDecoding(request: request, type: type, error: error)
                default:
                    throw HTTPError.requestFailed(request: request, type: type, error: error)
                }
            }
        }
        
        // Add task
        self.addActiveTask(id: request.id, task)
        
        guard let value = try await task.value as? T else {
            throw HTTPError.typeCastFailed(request: request, type: type, task: task)
        }
        
        return value
    }
    
}

// MARK: Task mgmt

extension HTTPClient {
    
    // TODO: Do we need these? Are they helpful?
    private func addActiveTask(id: String, _ task: Task<Response?, Error>) {
        activeTasks[id] = task
    }
    
    @discardableResult private func removeActiveTask(id: String) -> Task<Response?, Error>? {
        let task = activeTasks[id]
        activeTasks[id] = nil
        return task
    }
    
    private func addFailedTask(id: String, _ task: Task<Response?, Error>?) {
        failedTasks[id] = task
    }
    
    @discardableResult private func removeFailedTask(id: String) -> Task<Response?, Error>? {
        let task = failedTasks[id]
        failedTasks[id] = nil
        return task
    }
    
}

// MARK: Error

extension HTTPClient {
    
    enum HTTPError<T: HTTPClient.Response>: Swift.Error {
        case invalidURL(endpoint: any Endpoint<T>, type: T.Type, config: OpenAI.Configuration)
        case badResponse(request: URLRequest, response: URLResponse, type: T.Type)
        case failedDecoding(request: URLRequest, type: T.Type, error: DecodingError)
        case requestFailed(request: URLRequest, type: T.Type, error: Swift.Error)
        case typeCastFailed(request: URLRequest, type: T.Type, task: Task<HTTPClient.Response?, Swift.Error>)
    }
    
}

// MARK: Utils

fileprivate extension URLRequest {
    
    var id: String {
        description
    }
    
}
