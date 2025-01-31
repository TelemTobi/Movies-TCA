//
//  RootNavigator.swift
//  Presentation
//
//  Created by Telem Tobi on 04/03/2024.
//

import Foundation
import ComposableArchitecture
import SplashFeature
import HomeNavigator

@Reducer
public struct RootNavigator {
    
    @ObservableState
    public struct State: Equatable {
        var destination: Destination.State
        
        public init(destination: Destination.State = .splash(SplashFeature.State())) {
            self.destination = destination
        }
    }
    
    public enum Action {
        case destination(Destination.Action)
    }
    
    public init() {}

    public var body: some ReducerOf<Self> {
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
    public struct Destination {
        @ObservableState
        public enum State: Equatable {
            case splash(SplashFeature.State)
            case home(HomeNavigator.State)
        }
        
        public enum Action {
            case splash(SplashFeature.Action)
            case home(HomeNavigator.Action)
        }
        
        public var body: some ReducerOf<Self> {
            Scope(state: \.splash, action: \.splash, child: SplashFeature.init)
            Scope(state: \.home, action: \.home, child: HomeNavigator.init)
        }
    }
}
