//
//  SplashFeature.swift
//  Presentation
//
//  Created by Telem Tobi on 04/03/2024.
//

import Foundation
import ComposableArchitecture
import Models

@Reducer
public struct SplashFeature {
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }
    
    public enum Action: ViewAction, Equatable {
        @CasePathable
        public enum View: Equatable {
            case onAppear
        }
        
        @CasePathable
        public enum Navigation: Equatable {
            case splashCompleted
        }
        
        case view(View)
        case navigation(Navigation)
        case fetchGenres
        case genresResult(Result<GenresResponse, TmdbError>)
    }
    
    @Dependency(\.interactor) private var interactor
    
    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return reduceViewAction(&state, viewAction)
                
            case .fetchGenres:
                return .run { send in
                    let genresResult = await interactor.fetchGenres()
                    await send(.genresResult(genresResult))
                }
                
            case let .genresResult(result):
                switch result {
                case .success:
                    return .send(.navigation(.splashCompleted))
                    
                case let .failure(error):
                    customDump(error) // TODO: Handle error
                    return .none
                }
                
            case .navigation:
                return .none
            }
        }
    }
    
    private func reduceViewAction(_ state: inout State, _ action: Action.View) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .send(.fetchGenres)
        }
    }
}

extension DependencyValues {
    fileprivate var interactor: SplashInteractor {
        get { self[SplashInteractor.self] }
    }
}
