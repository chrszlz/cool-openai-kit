//
//  Endpoint.swift
//  ToolKit
//
//  Created by chris on 1/13/23.
//

import Foundation

public protocol Endpoint<Response>: Sendable {
    associatedtype Response: HTTPClient.Response
    
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var header: [String: String]? { get }
    var body: (Encodable & Sendable)? { get }
}

extension URLRequest {
    
    /// Creates and initializes a URLRequest with the given endpoint and HTTP headers.
    /// - parameter: endpoint The endpoint for the request.
    /// - parameter: headers Dictionary containing necessary HTTP headers. Entries with
    /// empty or `nil` values will be skipped.
    init?<T>(_ encoder: JSONEncoder, endpoint: any Endpoint<T>, headers: [String: String?] = [:]) {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        components.path = endpoint.path
        
        guard let url = components.url else {
            return nil
        }
        
        self.init(url: url)
        
        self.httpMethod = endpoint.method.rawValue
        
        for (field, value) in headers where value != nil {
            self.setValue(value, forHTTPHeaderField: field)
        }
        
        if let body = endpoint.body {
            do {
                self.httpBody = try encoder.encode(body)
            } catch let error {
                debugPrint("Warning - URLRequest failed to serialize `body` data: ", error.localizedDescription)
                return nil
            }
        }
    }
    
}
