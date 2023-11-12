//
//  AppFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 12/11/2023.
//

import Foundation
import ComposableArchitecture

struct AppReducer: Reducer {
    
    struct State: Equatable {
        var isSplashRunning = true
        var main = Main.State()
    }
    
    enum Action: Equatable {
        case onFirstAppear
        case dataLoaded([Movie.Genre])
        case main(Main.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onFirstAppear:
                // TODO: Fetch genres
                return .send(.dataLoaded([]))
            
            case let .dataLoaded(genres):
                state.isSplashRunning = false
                state.main.genres = genres
                return .none
                
            case .main:
                return .none
            }
        }
        
        Scope(state: \.main, action: /Action.main) {
            Main()
        }
    }
}
