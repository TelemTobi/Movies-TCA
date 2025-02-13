//
//  GenreDetails.swift
//  Presentation
//
//  Created by Telem Tobi on 13/02/2025.
//

import Foundation
import ComposableArchitecture
import Models

@Reducer
public struct GenreDetails {
    
    @ObservableState
    public struct State: Equatable {
        let genre: Genre
        
        public init(genre: Genre) {
            self.genre = genre
        }
    }
    
    public enum Action: ViewAction, Equatable {
        @CasePathable
        public enum View: Equatable {
            case onAppear
        }
        
        @CasePathable
        public enum Navigation: Equatable {
            
        }
        
        case view(View)
        case navigation(Navigation)
    }
    
    @Dependency(\.interactor) private var interactor
    
    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return reduceViewAction(&state, viewAction)
                
            case .navigation:
                return .none
            }
        }
    }
    
    private func reduceViewAction(_ state: inout State, _ action: Action.View) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .none
        }
    }
}

extension DependencyValues {
    fileprivate var interactor: GenreDetailsInteractor {
        get { self[GenreDetailsInteractor.self] }
    }
}
