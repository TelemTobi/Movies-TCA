//
//  PreferencesFeature.swift
//  Presentation
//
//  Created by Telem Tobi on 29/11/2023.
//

import Foundation
import UIKit
import ComposableArchitecture
import Core

@Reducer
public struct PreferencesFeature {
    
    @ObservableState
    public struct State: Equatable {
        @Shared(.adultContent) var isAdultContentOn = false
        @Shared(.appearance) var appearance = .system
        
        public init() {}
    }
    
    public enum Action: ViewAction, Equatable {
        @CasePathable
        public enum View: Equatable {
            case onLanguageTap
            case onCloseButtonTap
        }
        
        case view(View)
        case onAdultContentToggle(Bool)
        case onAppearanceChange(Constants.Appearance)
    }
    
    @Dependency(\.interactor) private var interactor
    @Dependency(\.dismiss) private var dismiss
    @Dependency(\.isPresented) private var isPresented
    
    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return reduceViewAction(&state, viewAction)
                
            case let .onAdultContentToggle(newValue):
                state.$isAdultContentOn.withLock { $0 = newValue }
                return .none
                
            case let .onAppearanceChange(newValue):
                state.$appearance.withLock { $0 = newValue }
                return .none
            }
        }
    }
    
    private func reduceViewAction(_ state: inout State, _ action: Action.View) -> Effect<Action> {
        switch action {
        case .onLanguageTap:
            interactor.openAppSettings()
            return .none
            
        case .onCloseButtonTap:
            return .run { _ in
                guard isPresented else { return }
                await dismiss()
            }
        }
    }
}

extension DependencyValues {
    fileprivate var interactor: PreferencesInteractor {
        get { self[PreferencesInteractor.self] }
    }
}
