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
        var isAdultContentOn: Bool = Preferences.standard.isAdultContentOn
        var appearance: String = Preferences.standard.appearance
    }
    
    enum Action: ViewAction, Equatable {
        enum View: Equatable {
            case onLanguageTap
            case onCloseButtonTap
        }
        
        case view(View)
        case onAdultContentToggle(Bool)
        case onAppearanceChange(String)
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return reduceViewAction(&state, viewAction)
                
            case let .onAdultContentToggle(isOn):
                Preferences.standard.isAdultContentOn = isOn
                state.isAdultContentOn = isOn
                return .none
                
            case let .onAppearanceChange(appearance):
                Preferences.standard.appearance = appearance
                state.appearance = appearance
                return .none
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
            return .run { _ in await self.dismiss() }
        }
    }
}
