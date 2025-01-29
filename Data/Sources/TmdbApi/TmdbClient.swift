//
//  TmdbClient.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 15/11/2023.
//

import Foundation
import Networking
import Models
import Dependencies

public struct TmdbClient: Sendable {
    
    private let authenticator: Authenticator
    private let controller: NetworkingController<TmdbEndpoint, TmdbError>
    
    public init(environment: Networking.Environment = .live) {
        authenticator = TmdbAuthenticator()
        controller = NetworkingController(environment: environment, authenticator: authenticator)
    }
    
    public func fetchGenres() async -> Result<GenresResponse, TmdbError> {
        await controller.request(.listGenres)
    }
    
    public func fetchMovies(ofType type: MoviesListType) async -> Result<MoviesList, TmdbError> {
        await controller.request(.listMovies(type: type))
    }
    
    public func searchMovies(query: String) async -> Result<MoviesList, TmdbError> {
        await controller.request(.searchMovies(query: query))
    }
    
    public func discoverMovies(by genreId: Int) async -> Result<MoviesList, TmdbError> {
        await controller.request(.discoverMovies(genreId: genreId))
    }
    
    public func movieDetails(for movieId: Int) async -> Result<MovieDetails, TmdbError> {
        await controller.request(.movieDetails(id: movieId))
    }
}

extension TmdbClient: DependencyKey {
    public static let liveValue = TmdbClient(environment: .live)
    public static let testValue = TmdbClient(environment: .test)
    public static let previewValue = TmdbClient(environment: .preview)
}

public extension DependencyValues {
    var tmdbApi: TmdbClient {
        get { self[TmdbClient.self] }
    }
}
