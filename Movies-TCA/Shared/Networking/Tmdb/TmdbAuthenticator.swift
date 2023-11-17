//
//  TmdbAuthenticator.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 17/11/2023.
//

import Foundation
import Moya

struct TmdbAuthenticator: Authenticating {
    
    var authState: AuthState {
        // TODO: Check network connection
        return .reachable
    }
    
    func authenticate() async throws -> Bool {
        return true
    }
    
    func mapEndpoint(_ endpoint: Moya.Endpoint, for target: TargetTypeEndPoint) -> Moya.Endpoint {
        var headers: [String: String] = [
            "content-type": "application/json",
            "Authorization": Config.TmdbApi.accessToken
        ]
        
        target.headers?.forEach { (key, value) in
            headers[key] = value
        }
        
        return endpoint.adding(newHTTPHeaderFields: headers)
    }
}
