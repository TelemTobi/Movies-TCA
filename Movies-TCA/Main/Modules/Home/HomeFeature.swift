//
//  HomeFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 11/11/2023.
//

import Foundation
import ComposableArchitecture

struct Home: Reducer {
    
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        case onFirstAppear
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onFirstAppear:
                return .none
            }
        }
    }
}
