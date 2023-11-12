//
//  SplashFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 12/11/2023.
//

import Foundation
import ComposableArchitecture

struct Splash: Reducer {
    
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        case onFirstAppear
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onFirstAppear:
                // TODO: Fetch genres
                return .none
            }
        }
    }
}
