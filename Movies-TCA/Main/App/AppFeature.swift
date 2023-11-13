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
        var isLoading = true
        var home = Home.State()
    }
    
    enum Action: Equatable {
        case onFirstAppear
        case genresLoaded([Movie.Genre])
        case home(Home.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onFirstAppear:
                // TODO: Fetch genres
                return .run { send in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        send(.genresLoaded([]))
                    }
                }
                
            case let .genresLoaded(genres):
                state.home.genres = genres
                state.isLoading = false
                return .none
                
            case .home:
                return .none
            }
        }
    }
}
