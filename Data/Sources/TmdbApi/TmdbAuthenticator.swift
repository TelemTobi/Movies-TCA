//
//  TmdbAuthenticator.swift
//  TmdbApi
//
//  Created by Telem Tobi on 17/11/2023.
//

import Foundation
import Networking
import Core

struct TmdbAuthenticator: Authenticator {

    // TODO: Get back to that 👇
    private var isAdultContentOn: Bool {
        UserDefaults.standard.bool(forKey: "isAdultContentOn")
    }
    
    var state: AuthenticationState {
        // TODO: Check network connection
        return .reachable
    }
    
    func authenticate() async throws -> Bool {
        return true
    }
    
    func mapRequest(_ request: inout URLRequest) {
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.setValue(Config.TmdbApi.accessToken, forHTTPHeaderField: "Authorization")
        request.url?.append(queryItems: [URLQueryItem(name: "language", value: Constants.Language.current.rawValue)])
        request.url?.append(queryItems: [URLQueryItem(name: "include_adult", value: isAdultContentOn.description)])
    }
}
