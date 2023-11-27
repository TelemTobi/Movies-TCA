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
        var movieGenres: [Genre] = []
        
        var tabItem = TabItemFeature.State()
    }
    
    enum Action: Equatable {
        case onFirstAppear
        case onTabSelection(Tab)
        
        case tabItem(TabItemFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.tabItem, action: /Action.tabItem) {
            TabItemFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .onFirstAppear:
                // TODO: Figure that out
//                state.discover.genres = .init(uniqueElements: state.movieGenres)
                return .none
                
            case let .onTabSelection(tab):
                state.selectedTab = tab
                return .none
                
            case .tabItem:
                return .none
//            case .discover, .search:
//                return .none
            }
        }
    }
}

extension HomeFeature {
    
    enum Tab {
        case discover, search, watchlist
    }
}
