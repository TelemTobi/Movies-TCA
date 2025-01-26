//
//  TmdbClient.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 15/11/2023.
//

import Foundation
import Networking

struct TmdbClient {
    
    private let authenticator: Authenticator
    private let networkManager: NetworkingController<TmdbEndpoint, TmdbError>
    
    init(environment: Networking.Environment = .live) {
        authenticator = TmdbAuthenticator()
        networkManager = NetworkingController(environment: environment, authenticator: authenticator)
    }
    
    func fetchGenres() async -> Result<GenresResponse, TmdbError> {
        await networkManager.request(.listGenres)
    }
    
    func fetchMovies(ofType type: MoviesListType) async -> Result<MoviesList, TmdbError> {
        await networkManager.request(.listMovies(type: type))
    }
    
    func searchMovies(query: String) async -> Result<MoviesList, TmdbError> {
        await networkManager.request(.searchMovies(query: query))
    }
    
    func discoverMovies(by genreId: Int) async -> Result<MoviesList, TmdbError> {
        await networkManager.request(.discoverMovies(genreId: genreId))
    }
    
    func movieDetails(for movieId: Int) async -> Result<MovieDetails, TmdbError> {
        await networkManager.request(.movieDetails(id: movieId))
    }
}

extension TmdbClient {
    
    static let live = Self(environment: .live)
    static let test = Self(environment: .test)
    static let preview = Self(environment: .preview)
}
