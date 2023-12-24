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
        var selectedTab: Tab = .discover
        var discoverTabItem = TabItemFeature.State()
        var searchTabItem = TabItemFeature.State()
        var watchlistTabItem = TabItemFeature.State()
    }
    
    enum Action: Equatable {
        case onFirstAppear
        case onTabSelection(Tab)
        
        case discoverTabItem(TabItemFeature.Action)
        case searchTabItem(TabItemFeature.Action)
        case watchlistTabItem(TabItemFeature.Action)
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
                
            case .discoverTabItem, .searchTabItem, .watchlistTabItem:
                return .none
            }
        }
    }
}

extension HomeFeature {
    
    enum Tab {
        case discover, search, watchlist
    }
}
