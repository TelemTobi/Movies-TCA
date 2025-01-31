//
//  UseCases.swift
//  Domain
//
//  Created by Telem Tobi on 29/01/2025.
//

import Foundation
import Dependencies

public struct UseCases: Sendable {
    public let app: AppUseCases
    public let genres: GenresUseCases
    public let movies: MoviesUseCases
    public let movie: MovieUseCases
    
    init() {
        @Dependency(\.appUseCases) var app
        @Dependency(\.genresUseCases) var genres
        @Dependency(\.moviesUseCases) var movies
        @Dependency(\.movieUseCases) var movie
        
        self.app = app
        self.genres = genres
        self.movies = movies
        self.movie = movie
    }
}

extension UseCases: DependencyKey {
    public static let liveValue = UseCases()
    public static let testValue = UseCases()
}

public extension DependencyValues {
    var useCases: UseCases {
        get { self[UseCases.self] }
    }
}
