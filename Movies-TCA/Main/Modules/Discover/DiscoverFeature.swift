//
//  DiscoverFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 11/11/2023.
//

import Foundation
import ComposableArchitecture

struct Discover: Reducer {
    
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        case onFirstAppear
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .onFirstAppear:
                    // TODO: Perform network call
                    return .none
            }
        }
    }
}
