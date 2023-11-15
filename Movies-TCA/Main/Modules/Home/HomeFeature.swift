//
//  HomeFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 11/11/2023.
//

import Foundation
import ComposableArchitecture

struct Home: Reducer {
    
    struct State: Equatable {
        var selectedTab: Tab = .discover
        var movieGenres: [Genre] = []
        var discover = Discover.State()
    }
    
    enum Action: Equatable {
        case onFirstAppear
        case onTabSelection(Tab)
        case discover(Discover.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .onFirstAppear:
                    state.discover.movieGenres = state.movieGenres
                    return .none
                    
                case let .onTabSelection(tab):
                    state.selectedTab = tab
                    return .none
                    
                case .discover:
                    return .none
            }
        }
        
        Scope(state: \.discover, action: /Action.discover) {
            Discover()
        }
    }
}

extension Home {
    
    enum Tab {
        case discover, search, watchlist
    }
}
