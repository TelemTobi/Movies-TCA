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
        var isAdultContentOn: Bool = false
    }
    
    enum Action: Equatable {
        case onFirstAppear
        case onAdultContentToggle(Bool)
        case onLanguageTap
        case onCloseButtonTap
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onFirstAppear:
                state.isAdultContentOn = Config.UserPreferences.isAdultContentOn
                return .none
                
            case let .onAdultContentToggle(isOn):
                Config.UserPreferences.isAdultContentOn = isOn
                state.isAdultContentOn = isOn
                return .none
                
            case .onLanguageTap:
                DispatchQueue.main.async {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(url)
                }
                return .none
                
            case .onCloseButtonTap:
                return .run { _ in await self.dismiss() }
            }
        }
    }
}
