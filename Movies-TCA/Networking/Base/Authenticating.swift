//
//  Authenticating.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 17/11/2023.
//

import Foundation

enum AuthState {
    case reachable, notReachable, notLoggedIn
}

protocol Authenticating: Sendable {

    var authState: AuthState { get }

    /// Use this method to asynchronously authenticate the user
    func authenticate() async throws -> Bool
    
    /// Use this method to map the request right before the request is excecuted.
    func mapRequest(_ request: inout URLRequest)
}
