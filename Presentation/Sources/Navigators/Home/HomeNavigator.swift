//
//  HomeNavigator.swift
//  Presentation
//
//  Created by Telem Tobi on 16/03/2024.
//

import Foundation
import ComposableArchitecture
import DiscoveryNavigator
import SearchNavigator
import WatchlistNavigator

@Reducer
public struct HomeNavigator {
    
    @ObservableState
    public struct State: Equatable {
        var selectedTab: Tab = .discovery
        
        var discover = DiscoveryNavigator.State()
        var search = SearchNavigator.State()
        var watchlist = WatchlistNavigator.State()
        
        public init(selectedTab: Tab = .discovery) {
            self.selectedTab = selectedTab
        }
    }
    
    public enum Action {
        case onTabSelection(Tab)
        
        case discover(DiscoveryNavigator.Action)
        case search(SearchNavigator.Action)
        case watchlist(WatchlistNavigator.Action)
    }
    
    public init() {}

    public var body: some ReducerOf<Self> {
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
    
    public enum Tab {
        case discovery
        case search
        case watchlist
    }
}
