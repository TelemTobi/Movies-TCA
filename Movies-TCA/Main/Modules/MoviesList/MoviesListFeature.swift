//
//  MoviesListFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 26/11/2023.
//

import Foundation
import ComposableArchitecture

struct MoviesListFeature: Reducer {
    
    struct State: Equatable {
        let section: MoviesList.ListType
        let movies: IdentifiedArrayOf<Movie>
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
