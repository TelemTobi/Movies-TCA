//
//  DiscoveryInteractor.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 29/01/2025.
//

import Foundation
import Dependencies
import Models
import Domain

struct DiscoveryInteractor: Sendable {
    @Dependency(\.useCases.movies) private var movies
    
    func fetchMovieList(ofType type: MoviesListType) async -> Result<MovieList, TmdbError> {
        await movies.fetchList(type)
    }
}

extension DiscoveryInteractor: DependencyKey {
    static let liveValue = DiscoveryInteractor()
    static let testValue = DiscoveryInteractor()
}
