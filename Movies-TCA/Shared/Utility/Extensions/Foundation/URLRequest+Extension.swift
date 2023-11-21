//
//  URLRequest+Extension.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 19/11/2023.
//

import Foundation

extension URLRequest {
    
    init(_ endpoint: Endpoint) {
        self.init(url: endpoint.baseURL.appending(path: endpoint.path))
        self.httpMethod = endpoint.method.rawValue
        
        endpoint.headers?.forEach { (key, value) in
            self.setValue(value, forHTTPHeaderField: key)
        }
        
        switch endpoint.task {
            case .requestPlain:
                break
                
            case .requestEncodable(let encodable):
                self.httpBody = try? JSONEncoder().encode(encodable)
                
            case .requestParameters(let parameters):
                self.url?.append(queryItems: parameters.map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) })
                
            case .requestCompositeEncodable(let encodable, let parameters):
                self.httpBody = try? JSONEncoder().encode(encodable)
                self.url?.append(queryItems: parameters.map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) })
        }
    }
}
