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
    private let controller: NetworkingController<TmdbEndpoint, TmdbError>
    
    init(environment: Networking.Environment = .live) {
        authenticator = TmdbAuthenticator()
        controller = NetworkingController(environment: environment, authenticator: authenticator)
    }
    
    func fetchGenres() async -> Result<GenresResponse, TmdbError> {
        await controller.request(.listGenres)
    }
    
    func fetchMovies(ofType type: MoviesListType) async -> Result<MoviesList, TmdbError> {
        await controller.request(.listMovies(type: type))
    }
    
    func searchMovies(query: String) async -> Result<MoviesList, TmdbError> {
        await controller.request(.searchMovies(query: query))
    }
    
    func discoverMovies(by genreId: Int) async -> Result<MoviesList, TmdbError> {
        await controller.request(.discoverMovies(genreId: genreId))
    }
    
    func movieDetails(for movieId: Int) async -> Result<MovieDetails, TmdbError> {
        await controller.request(.movieDetails(id: movieId))
    }
}
