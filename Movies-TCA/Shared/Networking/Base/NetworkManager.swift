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
}
