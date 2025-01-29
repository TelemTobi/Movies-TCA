//
//  SearchInteractor.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 29/01/2025.
//

import Foundation
import Dependencies
import Models
import Domain

struct SearchInteractor: Sendable {
    @Dependency(\.useCases.movies) private var movies
    
    func discoverMovies(by genreId: Int) async -> Result<MovieList, TmdbError> {
        await movies.discoverByGenre(genreId)
    }
    
    func searchMovies(using query: String) async -> Result<MovieList, TmdbError> {
        await movies.search(query)
    }
}

extension SearchInteractor: DependencyKey {
    static let liveValue = SearchInteractor()
    static let testValue = SearchInteractor()
}
