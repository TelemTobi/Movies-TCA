//
//  PreferencesFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 29/11/2023.
//

import Foundation
import UIKit
import ComposableArchitecture

struct PreferencesFeature: Reducer {
    
    struct State: Equatable {
        var isAdultContentOn: Bool = Preferences.standard.isAdultContentOn
        var appearance: String = Preferences.standard.appearance
    }
    
    enum Action: Equatable {
        case onFirstAppear
        case onAdultContentToggle(Bool)
        case onLanguageTap
        case onAppearanceChange(String)
        case onCloseButtonTap
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onFirstAppear:
                return .none
                
            case let .onAdultContentToggle(isOn):
                Preferences.standard.isAdultContentOn = isOn
                state.isAdultContentOn = isOn
                return .none
                
            case .onLanguageTap:
                DispatchQueue.main.async {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(url)
                }
                return .none
                
            case let .onAppearanceChange(appearance):
                Preferences.standard.appearance = appearance
                state.appearance = appearance
                return .none
                
            case .onCloseButtonTap:
                return .run { _ in await self.dismiss() }
            }
        }
    }
}
