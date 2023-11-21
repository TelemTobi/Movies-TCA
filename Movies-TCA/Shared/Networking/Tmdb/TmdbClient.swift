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
    
    init() {
        authenticator = TmdbAuthenticator()
        networkManager = NetworkManager(authenticator: authenticator)
    }
    
    @Sendable
    func fetchGenres() async -> Result<GenresResponse, TmdbError> {
        await networkManager.request(.listGenres)
    }
    
    @Sendable
    func fetchNowPlayingMovies() async -> Result<MoviesList, TmdbError> {
        await networkManager.request(.listGenres) // TODO: ⚠️
    }
    
    @Sendable
    func fetchPopularMovies() async -> Result<MoviesList, TmdbError> {
        await networkManager.request(.listGenres) // TODO: ⚠️
    }
    
    @Sendable
    func fetchTopRatedMovies() async -> Result<MoviesList, TmdbError> {
        await networkManager.request(.listGenres) // TODO: ⚠️
    }
    
    @Sendable
    func fetchUpcomingMovies() async -> Result<MoviesList, TmdbError> {
        await networkManager.request(.listGenres) // TODO: ⚠️
    }
}

extension TmdbClient {
    
    static let live = Self()
}
