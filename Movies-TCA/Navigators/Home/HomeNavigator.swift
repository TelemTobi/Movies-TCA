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
        
        var discover = DiscoveryNavigator.State()
        var search = SearchNavigator.State()
        var watchlist = WatchlistNavigator.State()
    }
    
    enum Action {
        case onTabSelection(Tab)
        
        case discover(DiscoveryNavigator.Action)
        case search(SearchNavigator.Action)
        case watchlist(WatchlistNavigator.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.discover, action: \.discover, child: DiscoveryNavigator.init)
        
        Scope(state: \.search, action: \.search, child: SearchNavigator.init)
        
        Scope(state: \.watchlist, action: \.watchlist, child: WatchlistNavigator.init)
        
        Reduce { state, action in
            switch action {
            case let .onTabSelection(tab):
                state.selectedTab = tab
                return .none
                
            case .discover, .search, .watchlist:
                return .none
            }
        }
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
