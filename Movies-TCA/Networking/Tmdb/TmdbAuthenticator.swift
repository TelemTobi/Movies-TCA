//
//  TmdbAuthenticator.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 17/11/2023.
//

import Foundation
import Dependencies

struct TmdbAuthenticator: Authenticating {
    
    @Dependency(\.preferences) var preferences
    
    var authState: AuthState {
        // TODO: Check network connection
        return .reachable
    }
    
    func authenticate() async throws -> Bool {
        return true
    }
    
    func mapRequest(_ request: inout URLRequest) {
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.setValue(Config.TmdbApi.accessToken, forHTTPHeaderField: "Authorization")
        request.url?.append(queryItems: [URLQueryItem(name: "language", value: Preferences.Language.current.rawValue)])
        request.url?.append(queryItems: [URLQueryItem(name: "include_adult", value: preferences.getIsAdultContentOn().description)])
    }
}
