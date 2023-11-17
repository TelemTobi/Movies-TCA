//
//  Authenticating.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 17/11/2023.
//

import Foundation
import Moya

enum AuthState {
    case reachable, notReachable, notLoggedIn
}

protocol Authenticating {

    var authState: AuthState { get }

    // Can be used to asynchronously authenticate the user
    func authenticate() async throws -> Bool
    
    // Can be used to map the endpoint right before the request is excecuted
    func mapEndpoint(_ endpoint: Endpoint, for target: TargetTypeEndPoint) -> Endpoint
}
