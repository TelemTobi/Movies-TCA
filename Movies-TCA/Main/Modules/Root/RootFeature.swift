//
//  RootFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 14/11/2023.
//

import Foundation
import ComposableArchitecture

struct RootFeature: Reducer {
    
    struct State: Equatable {
        var isLoading = true
        
        var home = HomeFeature.State()
    }
    
    enum Action: Equatable {
        case onFirstAppear
        case loadingCompleted
        case home(HomeFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.home, action: /Action.home) {
            HomeFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .onFirstAppear:
                return .run { send in
                    try await Task.sleep(until: .now + .seconds(Constants.Stub.delay))
                    await send(.loadingCompleted)
                }
                
            case .loadingCompleted:
                state.isLoading = false
                return .none
                
            case .home:
                return .none
            }
        }
    }
}

