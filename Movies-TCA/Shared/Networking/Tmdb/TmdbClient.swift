//
//  TmdbClient.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 15/11/2023.
//

import Foundation
import Moya

struct TmdbClient: Networking {
    
    var provider = MoyaProvider<TmdbEndpoint>()
    var authenticator: Authenticating = TmdbAuthenticator()
    
    @Sendable
    func fetchGenres() async -> Result<GenresResponse, TmdbError> {
        await request(.listGenres)
    }
}

extension TmdbClient {
    
    static let live = Self()
}
