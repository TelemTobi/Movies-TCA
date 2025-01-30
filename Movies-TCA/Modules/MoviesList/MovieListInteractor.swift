//
//  MovieListInteractor.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 30/01/2025.
//

import Foundation
import Dependencies
import Models
import Domain

struct MovieListInteractor: Sendable {
    @Dependency(\.useCases.movie) private var movieUseCases
    
    func toggleWatchlist(for movie: Movie) async {
        await movieUseCases.toggleWatchlist(movie)
    }
}

extension MovieListInteractor: DependencyKey {
    static let liveValue = MovieListInteractor()
    static let testValue = MovieListInteractor()
}
