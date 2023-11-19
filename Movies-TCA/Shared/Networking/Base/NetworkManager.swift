//
//  NetworkManager.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 16/11/2023.
//

import Foundation

struct NetworkManager<E: Endpoint, F: Errorable> {
    
    let authenticator: Authenticating
    
    func request<T: Decodable & JsonResolver>(_ endpoint: E) async -> Result<T, F> {
        switch authenticator.authState {
        case .notReachable:
            return .failure(.init(.connectionError))
        case .notLoggedIn:
                return .failure(.init(.authError))
        case .reachable:
            break
        }
        
        do {
            if try await authenticator.authenticate() {
                return await makeRequest(endpoint)
            } else {
                return .failure(.init(.authError))
            }
        } catch {
            return .failure(.init(.connectionError))
        }
    }
    
    private func makeRequest<T: Decodable & JsonResolver>(_ endpoint: Endpoint) async -> Result<T, F> {
        var urlRequest = urlRequest(for: endpoint)
        authenticator.mapRequest(&urlRequest)
     
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299) ~= statusCode else {
                return await handleError(endpoint, data)
            }
            
            do {
                let model: T = try T
                    .resolve(data)
                    .parse(type: T.self, using: endpoint.dateDecodingStrategy, endpoint.keyDecodingStrategy)
                return .success(model)
                
            } catch {
                return await handleError(endpoint, data)
            }
            
        } catch {
            return .failure(.init(.unkownError))
        }
    }
    
    private func handleError<T: Decodable & JsonResolver>(_ endpoint: Endpoint, _ data: Data) async -> Result<T, F> {
        if let error = try? F.self
            .resolve(data)
            .parse(type: F.self, using: endpoint.dateDecodingStrategy, endpoint.keyDecodingStrategy) {
            return .failure(error)
        } else {
            return .failure(.init(.unkownError))
        }
    }
    
    private func urlRequest(for endpoint: Endpoint) -> URLRequest {
        URLRequest(
            url: endpoint.baseURL,
            path: endpoint.path,
            method: endpoint.method,
            task: endpoint.task,
            headers: endpoint.headers
        )
    }
}

extension URLRequest {
    init(url: URL, path: String, method: HTTPMethod, task: HTTPTask, headers: [String: String]?) {
        self.init(url: url.appending(path: path))
        self.httpMethod = method.rawValue
        
        headers?.forEach { (key, value) in
            self.setValue(value, forHTTPHeaderField: key)
        }
        
        switch task {
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

extension Data {
    
    func parse<T: Decodable>(type: T.Type, using dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = .iso8601, _ keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) throws -> T {
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = keyDecodingStrategy
        
        if let dateDecodingStrategy = dateDecodingStrategy {
            jsonDecoder.dateDecodingStrategy = dateDecodingStrategy
        }
        
        return try jsonDecoder.decode(type, from: self)
    }
}
