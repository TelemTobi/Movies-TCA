//
//  TmdbApiClient.swift
//  TmdbApi
//
//  Created by Telem Tobi on 15/11/2023.
//

import Foundation
import Networking
import Models
import Dependencies

public struct TmdbApiClient: Sendable {
    
    private let authenticator: Authenticator
    private let controller: NetworkingController<TmdbEndpoint, TmdbError>
    
    public init(environment: Networking.Environment = .live) {
        authenticator = TmdbAuthenticator()
        controller = NetworkingController(environment: environment, authenticator: authenticator)
    }
    
    public func fetchGenres() async -> Result<GenresResponse, TmdbError> {
        await controller.request(.listGenres)
    }
    
    public func fetchMovies(ofType type: MovieListType) async -> Result<MovieList, TmdbError> {
        await controller.request(.listMovies(type: type))
    }
    
    public func searchMovies(query: String) async -> Result<MovieList, TmdbError> {
        await controller.request(.searchMovies(query: query))
    }
    
    public func discoverMovies(by genreId: Int) async -> Result<MovieList, TmdbError> {
        await controller.request(.discoverMovies(genreId: genreId))
    }
    
    public func movieDetails(for movieId: Int) async -> Result<DetailedMovie, TmdbError> {
        await controller.request(.movieDetails(id: movieId))
    }
}

extension TmdbApiClient: DependencyKey {
    public static let liveValue = TmdbApiClient(environment: .live)
    public static let testValue = TmdbApiClient(environment: .test)
    public static let previewValue = TmdbApiClient(environment: .preview)
}

public extension DependencyValues {
    var tmdbApiClient: TmdbApiClient {
        get { self[TmdbApiClient.self] }
    }
}
