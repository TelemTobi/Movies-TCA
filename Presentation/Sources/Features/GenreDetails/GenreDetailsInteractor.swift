//
//  GenreDetailsInteractor.swift
//  Presentation
//
//  Created by Telem Tobi on 13/02/2025.
//

import Foundation
import Dependencies
import Models
import Domain

struct GenreDetailsInteractor: Sendable {
    @Dependency(\.useCases.movies.discoverByGenre) var discoverByGenre
}

extension GenreDetailsInteractor: DependencyKey {
    static let liveValue = GenreDetailsInteractor()
    static let testValue = GenreDetailsInteractor()
}
