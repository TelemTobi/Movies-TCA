//
//  SearchFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 24/11/2023.
//

import Foundation
import ComposableArchitecture

struct SearchFeature: Reducer {
    
    struct State: Equatable {
        @BindingState var searchInput: String = ""
    }
    
    enum Action: BindableAction {
        case onFirstAppear
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onFirstAppear:
                return .none
                
            case .binding(_):
                return .none
            }
        }
    }
}
