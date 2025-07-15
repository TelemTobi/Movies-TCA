//
//  SearchNavigator.swift
//  Presentation
//
//  Created by Telem Tobi on 20/03/2024.
//

import Foundation
import ComposableArchitecture
import Models
import SearchFeature
import PreferencesFeature
import MovieNavigator

@Reducer
public struct SearchNavigator {
    
    @ObservableState
    public struct State: Equatable {
        var root = Search.State()
        var path = StackState<Path.State>()
        @Presents var destination: Destination.State?
        @Presents var sheet: Sheet.State?
        
        public init(path: StackState<Path.State> = .init(), destination: Destination.State? = nil, sheet: Sheet.State? = nil) {
            self.path = path
            self.destination = destination
            self.sheet = sheet
        }
    }
    
    public enum Action {
        case root(Search.Action)
        case path(StackAction<Path.State, Path.Action>)
        case destination(PresentationAction<Destination.Action>)
        case sheet(PresentationAction<Sheet.Action>)
    }
    
    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.root, action: \.root, child: Search.init)
        
        Reduce { state, action in
            switch action {
            case let .root(.navigation(.presentMovie(movie))):
                state.destination = .movie(MovieNavigator.State(detailedMovie: .init(movie: movie)))
                return .none
                
            case .root(.navigation(.presentPreferences)):
                state.sheet = .preferences(Preferences.State())
                return .none
                
            case .root, .path, .destination, .sheet:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
        .ifLet(\.$destination, action: \.destination)
        .ifLet(\.$sheet, action: \.sheet)
    }
}

extension SearchNavigator {
        
    @Reducer(state: .equatable)
    public enum Destination {
        case movie(MovieNavigator)
    }
    
    @Reducer(state: .equatable)
    public enum Sheet {
        case preferences(Preferences)
    }
    
    @Reducer(state: .equatable)
    public enum Path {
        
    }
}
