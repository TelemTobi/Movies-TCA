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
        @PresentationState var destination: Destination.State?
        
        var selectedTab: Tab = .discover
        var discover = DiscoverFeature.State()
        var search = SearchFeature.State()
        var watchlist = WatchlistFeature.State()
        
    }
    
    enum Action: Equatable {
        case destination(PresentationAction<Destination.Action>)
        
        case onFirstAppear
        case onTabSelection(Tab)
        case onPreferencesTap
        case setGenres(IdentifiedArrayOf<Genre>)
        
        case discover(DiscoverFeature.Action)
        case search(SearchFeature.Action)
        case watchlist(WatchlistFeature.Action)        
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
        Scope(state: \.discover, action: /Action.discover) {
            DiscoverFeature()
        }

        Scope(state: \.search, action: /Action.search) {
            SearchFeature()
        }
        
        Scope(state: \.watchlist, action: /Action.watchlist) {
            WatchlistFeature()
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
                
            case let .setGenres(genres):
                state.search.genres = genres
                return .none
                
            case let .discover(.onMovieTap(movie)), let .search(.onMovieTap(movie)):
                state.destination = .presentedMovie(MovieFeature.State(movieDetails: .init(movie: movie)))
                return .none
                
            case .destination, .discover, .search, .watchlist:
                return .none
            }
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
