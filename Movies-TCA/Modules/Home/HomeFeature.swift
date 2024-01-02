//
//  HomeFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 11/11/2023.
//

import Foundation
import ComposableArchitecture

struct HomeFeature: Reducer {
    
    struct State: Equatable {
        var path = StackState<Path.State>()
        @PresentationState var destination: Destination.State?
        
        var selectedTab: Tab = .discover
        var discoverTabItem = TabItemFeature.State()
        var searchTabItem = TabItemFeature.State()
        var watchlistTabItem = TabItemFeature.State()
        
    }
    
    enum Action: Equatable {
        case path(StackAction<Path.State, Path.Action>)
        case destination(PresentationAction<Destination.Action>)
        
        case onFirstAppear
        case onTabSelection(Tab)
        case onPreferencesTap
        
        case discoverTabItem(TabItemFeature.Action)
        case searchTabItem(TabItemFeature.Action)
        case watchlistTabItem(TabItemFeature.Action)
        
        
    }
    
    struct Path: Reducer {
        
        enum State: Equatable {
            case moviesList(MoviesListFeature.State)
        }
        
        enum Action: Equatable {
            case moviesList(MoviesListFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.moviesList, action: /Action.moviesList) {
                MoviesListFeature()
            }
        }
    }
    
    struct Destination: Reducer {
        
        enum State: Equatable {
            case presentedMovie(MovieFeature.State)
            case preferences(PreferencesFeature.State)
        }
        
        enum Action: Equatable {
            case presentedMovie(MovieFeature.Action)
            case preferences(PreferencesFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.presentedMovie, action: /Action.presentedMovie) {
                MovieFeature()
            }
        }
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.discoverTabItem, action: /Action.discoverTabItem) {
            TabItemFeature()
        }
        
        Scope(state: \.searchTabItem, action: /Action.searchTabItem) {
            TabItemFeature()
        }
        
        Scope(state: \.watchlistTabItem, action: /Action.watchlistTabItem) {
            TabItemFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .onFirstAppear:
                return .none
                
            case let .onTabSelection(tab):
                state.selectedTab = tab
                return .none
                
            case .onPreferencesTap:
                state.destination = .preferences(PreferencesFeature.State())
                return .none
                
            case .path, .destination, .discoverTabItem, .searchTabItem, .watchlistTabItem:
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
        .ifLet(\.$destination, action: /Action.destination) {
            Destination()
        }
    }
}

extension HomeFeature {
    
    enum Tab {
        case discover, search, watchlist
        
        var title: String {
            return switch self {
            case .discover: "Discover"
            case .search: "Search"
            case .watchlist: "Watchlist"
            }
        }
    }
}
