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
        
        var discover = DiscoverNavigator.State()
        var search = SearchFeature.State()
        var watchlist = WatchlistFeature.State()
    }
    
    enum Action {
        case onTabSelection(Tab)
        
        case discover(DiscoverNavigator.Action)
        case search(SearchFeature.Action)
        case watchlist(WatchlistFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.discover, action: \.discover, child: DiscoverNavigator.init)
        
        Scope(state: \.search, action: \.search, child: SearchFeature.init)
        
        Scope(state: \.watchlist, action: \.watchlist, child: WatchlistFeature.init)
        
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
