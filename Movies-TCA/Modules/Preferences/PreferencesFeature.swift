//
//  PreferencesFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 29/11/2023.
//

import Foundation
import UIKit
import ComposableArchitecture

@Reducer
struct PreferencesFeature {
    
    @ObservableState
    struct State: Equatable {
        var isAdultContentOn: Bool
        
        @Shared(.appStorage("appearance"))
        var appearance: Constants.Appearance = .system
        
        init() {
            @Dependency(\.preferences) var preferences
            isAdultContentOn = preferences.getIsAdultContentOn()
        }
    }
    
    enum Action: ViewAction, Equatable {
        @CasePathable
        enum View: Equatable {
            case onLanguageTap
            case onCloseButtonTap
        }
        
        case view(View)
        case onAdultContentToggle(Bool)
        case onAppearanceChange(String)
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.isPresented) var isPresented
    @Dependency(\.preferences) var preferences
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return reduceViewAction(&state, viewAction)
                
            case let .onAdultContentToggle(newValue):
                preferences.setIsAdultContentOn(newValue)
                state.isAdultContentOn = newValue
                return .none
                
            case let .onAppearanceChange(newValue):
                state.appearance = Constants.Appearance(rawValue: newValue) ?? .system
                
                return .run { _ in
                    guard isPresented else { return }
                    await dismiss()
                }
            }
        }
    }
    
    private func reduceViewAction(_ state: inout State, _ action: Action.View) -> Effect<Action> {
        switch action {
        case .onLanguageTap:
            DispatchQueue.main.async { // TODO: Use mainQueue dependency
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(url)
            }
            return .none
            
        case .onCloseButtonTap:
            return .run { _ in
                guard isPresented else { return }
                await dismiss()
            }
        }
    }
}
