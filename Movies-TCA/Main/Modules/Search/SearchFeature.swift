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
        var isLoading = false
        var genres: IdentifiedArrayOf<Genre> = []
        
        @BindingState var searchInput: String = ""
    }
    
    enum Action: Equatable, BindableAction {
        case onFirstAppear
        case onMovieTap(_ movie: Movie)
        
        case binding(BindingAction<State>)
    }
    
    @Dependency(\.tmdbClient) var tmdbClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onFirstAppear:
                return .none
                
            case .binding(_):
                return .none
                
            // MARK: Handled in parent feature
            case .onMovieTap:
                return .none
                
            }
        }
    }
}
