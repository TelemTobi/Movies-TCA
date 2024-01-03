//
//  WatchlistFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 06/12/2023.
//

import Foundation
import ComposableArchitecture

struct WatchlistFeature: Reducer {
    
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        case onPreferencesTap
        case onMovieTap(_ movie: Movie)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            // MARK: Handled in parent feature
            case .onPreferencesTap, .onMovieTap:
                return .none
            }
        }
    }
}
