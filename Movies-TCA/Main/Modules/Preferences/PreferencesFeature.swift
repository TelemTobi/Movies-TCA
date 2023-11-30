//
//  PreferencesFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 29/11/2023.
//

import Foundation
import ComposableArchitecture

struct PreferencesFeature: Reducer {
    
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        case onCloseButtonTap
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onCloseButtonTap:
                return .run { _ in await self.dismiss() }
            }
        }
    }
}
