//
//  HomeNavigator.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 16/03/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HomeNavigator {
    
    @ObservableState
    struct State: Equatable {
        var root = HomeFeature.State()
        var path = StackState<Path.State>()
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case root(HomeFeature.Action)
        case path(StackAction<Path.State, Path.Action>)
        case destination(PresentationAction<Destination.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.root, action: \.root, child: HomeFeature.init)
        
        Reduce { state, action in
            switch action {
            case .root, .path, .destination:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
        .ifLet(\.$destination, action: \.destination)
    }
}

extension HomeNavigator {
    
    @Reducer(state: .equatable)
    enum Destination {
        
    }
    
    @Reducer(state: .equatable)
    enum Path {
        
    }
}
