//
//  TabItemFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 26/11/2023.
//

import Foundation
import ComposableArchitecture

struct TabItemFeature: Reducer {
    
    struct State: Equatable {
        var path = StackState<Path.State>()
        
        var discover = DiscoverFeature.State()
        var search = SearchFeature.State()
    }
    
    enum Action: Equatable {
        case path(StackAction<Path.State, Path.Action>)
        
        case discover(DiscoverFeature.Action)
        case search(SearchFeature.Action)
    }
    
    struct Path: Reducer {
        
        enum State: Equatable {
            
        }
        
        enum Action: Equatable {
            
        }
        
        var body: some ReducerOf<Self> {
            Reduce { state, action in
                switch action {
                
                }
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
        
        Reduce { state, action in
            switch action {
            case .path:
                return .none
                
            case .discover, .search:
                return .none
            }
        }
    }
}
