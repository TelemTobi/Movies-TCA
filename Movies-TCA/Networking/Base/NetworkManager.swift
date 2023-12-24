//
//  NetworkManager.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 16/11/2023.
//

import Foundation

struct NetworkManager<E: Endpoint, F: Errorable> {
    
    let authenticator: Authenticating
    let environment: Constants.Environment
    
    func request<T: Decodable & JsonResolver>(_ endpoint: E) async -> Result<T, F> {
        guard environment == .live else {
            return await makeStubRequest(endpoint)
        }
        
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
        var urlRequest = URLRequest(endpoint)
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
                return .failure(.init(.decodingError))
            }
            
        } catch {
            return .failure(.init(.unknownError))
        }
    }
    
    private func makeStubRequest<T: Decodable & JsonResolver>(_ endpoint: Endpoint) async -> Result<T, F> {
        do {
            try await Task.sleep(until: .now + .seconds(Constants.Stub.delay))
            
            let model: T = try T
                .resolve(endpoint.sampleData ?? Data())
                .parse(type: T.self, using: endpoint.dateDecodingStrategy, endpoint.keyDecodingStrategy)
            return .success(model)
            
        } catch {
            return .failure(.init(.decodingError))
        }
    }
    
    private func handleError<T: Decodable & JsonResolver>(_ endpoint: Endpoint, _ data: Data) async -> Result<T, F> {
        if let error = try? F.self
            .resolve(data)
            .parse(type: F.self, using: endpoint.dateDecodingStrategy, endpoint.keyDecodingStrategy) {
            return .failure(error)
        } else {
            return .failure(.init(.unknownError))
        }
    }
}
