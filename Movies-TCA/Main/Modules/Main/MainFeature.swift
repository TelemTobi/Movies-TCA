//
//  MainFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 11/11/2023.
//

import Foundation
import ComposableArchitecture

struct Main: Reducer {
    
    struct State: Equatable {
        var selectedTab: Tab = .home
        var home = Home.State()
    }
    
    enum Action: Equatable {
        case onFirstAppear
        case onTabSelection(Tab)
        case home(Home.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .onTabSelection(tab):
                state.selectedTab = tab
                return .none
                
            case .onFirstAppear, .home:
                return .none
            }
        }
        
        Scope(state: \.home, action: /Action.home) {
            Home()
        }
    }
}

extension Main {
    
    enum Tab {
        case home, search, watchlist
    }
}
