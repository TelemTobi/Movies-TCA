//
//  MovieNavigator.swift
//  Presentation
//
//  Created by Telem Tobi on 24/03/2024.
//

import Foundation
import ComposableArchitecture
import Models
import MovieFeature

@Reducer
public struct MovieNavigator {
    
    @ObservableState
    public struct State: Equatable {
        var root: MovieFeature.State
        var path = StackState<Path.State>()
        
        public init(movieDetails: MovieDetails, path: StackState<Path.State> = .init()) {
            self.root = .init(movieDetails: movieDetails)
        }
    }
    
    public enum Action {
        case root(MovieFeature.Action)
        case path(StackAction<Path.State, Path.Action>)
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.isPresented) var isPresented
    
    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.root, action: \.root, child: MovieFeature.init)
        
        Reduce { state, action in
            switch action {
            case let .root(.navigation(.pushRelatedMovie(movie))),
                 let .path(.element(_, action: .relatedMovie(.navigation(.pushRelatedMovie(movie))))):
                state.path.append(.relatedMovie(MovieFeature.State(movieDetails: .init(movie: movie))))
                return .none
                
            case .root(.navigation(.dismissFlow)),
                 .path(.element(_, action: .relatedMovie(.navigation(.dismissFlow)))):
                guard isPresented else { return .none }
                
                return .run { _ in await dismiss() }
                
            case .root, .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension MovieNavigator {
    
    @Reducer(state: .equatable)
    public enum Path {
        case relatedMovie(MovieFeature)
    }
}
