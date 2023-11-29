//
//  MovieFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 24/11/2023.
//

import Foundation
import ComposableArchitecture

struct MovieFeature: Reducer {
    
    struct State: Equatable {
        var movie: Movie
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
