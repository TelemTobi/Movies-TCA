//
//  MovieNavigator.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 24/03/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MovieNavigator {
    
    @ObservableState
    struct State: Equatable {
        var root: MovieFeature.State
        var path = StackState<Path.State>()
        
        init(movieDetails: MovieDetails) {
            self.root = .init(movieDetails: movieDetails)
        }
    }
    
    enum Action {
        case root(MovieFeature.Action)
        case path(StackAction<Path.State, Path.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.root, action: \.root, child: MovieFeature.init)
        
        Reduce { state, action in
            switch action {
                
            case .root, .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension MovieNavigator {
    
    @Reducer(state: .equatable)
    enum Path {
        case relatedMovie(MovieFeature)
    }
}
