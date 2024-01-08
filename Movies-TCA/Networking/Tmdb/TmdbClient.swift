//
//  TmdbClient.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 15/11/2023.
//

import Foundation

struct TmdbClient {
    
    private let authenticator: Authenticating
    private let networkManager: NetworkManager<TmdbEndpoint, TmdbError>
    
    init(environment: Constants.Environment = .live) {
        authenticator = TmdbAuthenticator()
        networkManager = NetworkManager(authenticator: authenticator, environment: environment)
    }
    
    @Sendable
    func fetchGenres() async -> Result<GenresResponse, TmdbError> {
        await networkManager.request(.listGenres)
    }
    
    @Sendable
    func fetchMovies(ofType type: MoviesListType) async -> Result<MoviesList, TmdbError> {
        await networkManager.request(.listMovies(type: type))
    }
    
    @Sendable
    func searchMovies(query: String) async -> Result<MoviesList, TmdbError> {
        await networkManager.request(.searchMovies(query: query))
    }
    
    @Sendable
    func discoverMovies(by genreId: Int) async -> Result<MoviesList, TmdbError> {
        await networkManager.request(.discoverMovies(genreId: genreId))
    }
    
    @Sendable
    func movieDetails(for movieId: Int) async -> Result<MovieDetails, TmdbError> {
        await networkManager.request(.movieDetails(id: movieId))
    }
}

extension TmdbClient {
    
    static let live = Self(environment: .live)
    static let test = Self(environment: .test)
}
