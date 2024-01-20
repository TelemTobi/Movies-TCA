//
//  WatchlistFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 06/12/2023.
//

import Foundation
import ComposableArchitecture

struct WatchlistFeature: Reducer {
    
    struct State: Equatable {
        var likedMovies: IdentifiedArrayOf<Movie> = []
    }
    
    enum Action: Equatable {
        case onPreferencesTap
        case onMovieTap(Movie)
        case setLikedMovies([LikedMovie])
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case let .setLikedMovies(likedMovies):
                state.likedMovies = .init(uniqueElements: likedMovies.map { $0.toMovie })
                return .none
                
            // MARK: Handled in parent feature
            case .onPreferencesTap, .onMovieTap:
                return .none
            }
        }
    }
}
