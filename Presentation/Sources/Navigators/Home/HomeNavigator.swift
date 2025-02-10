//
//  HomeNavigator.swift
//  Presentation
//
//  Created by Telem Tobi on 16/03/2024.
//

import Foundation
import ComposableArchitecture
import MoviesNavigator
import SearchNavigator

@Reducer
public struct HomeNavigator {
    
    @ObservableState
    public struct State: Equatable {
        var selectedTab: Tab = .movies
        
        var movies = MoviesNavigator.State()
        var search = SearchNavigator.State()
        
        public init(selectedTab: Tab = .movies) {
            self.selectedTab = selectedTab
        }
    }
    
    public enum Action {
        case onTabSelection(Tab)
        
        case movies(MoviesNavigator.Action)
        case search(SearchNavigator.Action)
    }
    
    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.movies, action: \.movies, child: MoviesNavigator.init)
        
        Scope(state: \.search, action: \.search, child: SearchNavigator.init)
        
        Reduce { state, action in
            switch action {
            case let .onTabSelection(tab):
                state.selectedTab = tab
                return .none
                
            case .movies, .search:
                return .none
            }
        }
    }
}

extension HomeNavigator {
    
    public enum Tab {
        case movies
        case search
    }
}
