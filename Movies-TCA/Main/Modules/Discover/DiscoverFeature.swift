//
//  DiscoverFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 11/11/2023.
//

import Foundation
import ComposableArchitecture

struct DiscoverFeature: Reducer {
    
    struct State: Equatable {
        var isLoading = true
        var movieGenres: IdentifiedArrayOf<Genre> = []
        var movies: [Section: IdentifiedArrayOf<Movie>] = [:]
    }
    
    enum Action: Equatable {
        case onFirstAppear
        case loadMovies
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .onFirstAppear:
                    return .send(.loadMovies)
                    
                case .loadMovies:
                    // TODO: Perform network call
                    return .none
            }
        }
    }
}

extension DiscoverFeature {
    
    enum Section: CaseIterable {
        case nowPlaying, popular, topRated, upcoming
        
        var title: String {
            return switch self {
                case .nowPlaying: "Now Playing"
                case .popular: "Popular"
                case .topRated: "Top Rated"
                case .upcoming: "Upcoming"
            }
        }
    }
}
