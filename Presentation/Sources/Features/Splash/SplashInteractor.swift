//
//  SplashInteractor.swift
//  Presentation
//
//  Created by Telem Tobi on 29/01/2025.
//

import Foundation
import Dependencies
import Models
import Domain

struct SplashInteractor: Sendable {
    @Dependency(\.useCases.genres) private var genres
    
    func fetchGenres() async -> Result<GenresResponse, TmdbError> {
        await genres.fetch()
    }
}

extension SplashInteractor: DependencyKey {
    static let liveValue = SplashInteractor()
    static let testValue = SplashInteractor()
}
