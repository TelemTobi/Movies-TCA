//
//  MoviesListFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 26/11/2023.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MoviesListFeature {
    
    @ObservableState
    struct State: Equatable {
        var listType: MoviesListType?
        let movies: IdentifiedArrayOf<Movie>
    }
    
    enum Action: ViewAction, Equatable {
        enum View: Equatable {
            case onFirstAppear
            case onMovieTap(Movie)
            case onMovieLike(Movie)
        }
        
        case view(View)
    }
    
    @Dependency(\.tmdbClient) var tmdbClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onFirstAppear):
                return .none
                
            // MARK: Handled in parent feature
            case .view(.onMovieTap), .view(.onMovieLike):
                return .none
            }
        }
    }
}
