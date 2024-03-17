//
//  HomeNavigator.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 16/03/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HomeNavigator {
    
    @ObservableState
    struct State: Equatable {
        var selectedTab: Tab = .discover
        
        var discover = DiscoverFeature.State()
        var search = SearchFeature.State()
        var watchlist = WatchlistFeature.State()
        
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case onTabSelection(Tab)
        
        case discover(DiscoverFeature.Action)
        case search(SearchFeature.Action)
        case watchlist(WatchlistFeature.Action)
        
        case destination(PresentationAction<Destination.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.discover, action: \.discover, child: DiscoverFeature.init)
        
        Scope(state: \.search, action: \.search, child: SearchFeature.init)
        
        Scope(state: \.watchlist, action: \.watchlist, child: WatchlistFeature.init)
        
        Reduce { state, action in
            switch action {
            case let .onTabSelection(tab):
                state.selectedTab = tab
                return .none
                
            case let .discover(.navigation(.presentMovie(movie))):
                state.destination = .movie(MovieFeature.State(movieDetails: .init(movie: movie)))
                return .none
                
            case .discover(.navigation(.presentPreferences)):
                state.destination = .preferences(PreferencesFeature.State())
                return .none
                
            case .discover, .search, .watchlist, .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension HomeNavigator {
    
    @Reducer(state: .equatable)
    enum Destination {
        case movie(MovieFeature)
        case preferences(PreferencesFeature)
    }
}

extension HomeNavigator {
    
    enum Tab {
        case discover, search, watchlist
        
        var title: String {
            return switch self {
            case .discover: "Discovery"
            case .search: "Search"
            case .watchlist: "Watchlist"
            }
        }
    }
}
