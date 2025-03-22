//
//  MoviesNavigator.swift
//  Presentation
//
//  Created by Telem Tobi on 17/03/2024.
//

import Foundation
import ComposableArchitecture
import MoviesHomepageFeature
import MovieCollectionFeature
import GenreDetailsFeature
import PreferencesFeature
import MovieNavigator
import DesignSystem

@Reducer
public struct MoviesNavigator {
    
    @ObservableState
    public struct State: Equatable {
        var root = MoviesHomepage.State()
        var path = StackState<Path.State>()
        @Presents var destination: Destination.State?
        
        var transitionSource: TransitionSource?
        
        public init(path: StackState<Path.State> = StackState<Path.State>(), destination: Destination.State? = nil) {
            self.path = path
            self.destination = destination
        }
    }
    
    public enum Action {
        case root(MoviesHomepage.Action)
        case path(StackAction<Path.State, Path.Action>)
        case destination(PresentationAction<Destination.Action>)
    }
    
    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.root, action: \.root, child: MoviesHomepage.init)
        
        Reduce { state, action in
            switch action {
            case let .root(.navigation(.movieDetails(movie, transitionSource))):
                state.transitionSource = transitionSource
                state.destination = .movie(MovieNavigator.State(detailedMovie: .init(movie: movie)))
                return .none
                
            case .destination(.dismiss):
                state.transitionSource = nil
                return .none
                
            case let .path(.element(_, action: .movieList(.navigation(.presentMovie(movie))))):
                state.destination = .movie(MovieNavigator.State(detailedMovie: .init(movie: movie)))
                return .none
                
            case let .root(.navigation(.expandSection(section, movieList))):
                let movieListState = MovieCollection.State(movieList: movieList, section: section)
                state.path.append(.movieList(movieListState))
                return .none
                
            case let .root(.navigation(.genreDetails(genre))):
                state.path.append(.genreDetails(GenreDetails.State(genre: genre)))
                return .none
                
            case .root, .path, .destination:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
        .ifLet(\.$destination, action: \.destination)
    }
}

extension MoviesNavigator {
        
    @Reducer(state: .equatable)
    public enum Destination {
        case movie(MovieNavigator)
        case preferences(Preferences)
    }
    
    @Reducer(state: .equatable)
    public enum Path {
        case movieList(MovieCollection)
        case genreDetails(GenreDetails)
    }
}
