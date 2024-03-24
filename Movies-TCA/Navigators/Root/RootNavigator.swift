//
//  RootNavigator.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 04/03/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RootNavigator {
    
    @ObservableState
    struct State: Equatable {
        var destination: Destination.State = .splash(SplashFeature.State())
    }
    
    enum Action {
        case destination(Destination.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.destination, action: \.destination, child: Destination.init)
        
        Reduce { state, action in
            switch action {
            case .destination(.splash(.navigation(.splashCompleted))):
                state.destination = .home(HomeNavigator.State())
                return .none
                
            case .destination:
                return .none
            }
        }
    }
}

extension RootNavigator {
    
    @Reducer
    struct Destination {
        
        @ObservableState
        enum State: Equatable {
            case splash(SplashFeature.State)
            case home(HomeNavigator.State)
        }
        
        enum Action {
            case splash(SplashFeature.Action)
            case home(HomeNavigator.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.splash, action: \.splash, child: SplashFeature.init)
            Scope(state: \.home, action: \.home, child: HomeNavigator.init)
        }
    }
}
