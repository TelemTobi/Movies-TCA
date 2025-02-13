//
//  MovieListInteractor.swift
//  Presentation
//
//  Created by Telem Tobi on 30/01/2025.
//

import Foundation
import Dependencies
import Models
import Domain

struct MovieCollectionInteractor: Sendable {
    @Dependency(\.useCases.movie) private var movieUseCases
    
    func toggleWatchlist(for movie: Movie) async {
        await movieUseCases.toggleWatchlist(movie)
    }
}

extension MovieCollectionInteractor: DependencyKey {
    static let liveValue = MovieCollectionInteractor()
    static let testValue = MovieCollectionInteractor()
}
