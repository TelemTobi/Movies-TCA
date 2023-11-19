//
//  TmdbClient.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 15/11/2023.
//

import Foundation

struct TmdbClient {
    
    var authenticator: Authenticating
    var networkManager: NetworkManager<TmdbEndpoint, TmdbError>
    
    init() {
        authenticator = TmdbAuthenticator()
        networkManager = NetworkManager(authenticator: authenticator)
    }
    
    func fetchGenres() async -> Result<GenresResponse, TmdbError> {
        await networkManager.request(.listGenres)
    }
}

extension TmdbClient {
    
    static let live = Self()
}
