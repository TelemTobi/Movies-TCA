//
//  TabItemFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 26/11/2023.
//

import Foundation
import ComposableArchitecture

struct TabItemFeature: Reducer {
    
    struct State: Equatable {
        var discover = DiscoverFeature.State()
        var search = SearchFeature.State()
        var watchlist = WatchlistFeature.State()
    }
    
    enum Action: Equatable {
        case discover(DiscoverFeature.Action)
        case search(SearchFeature.Action)
        case watchlist(WatchlistFeature.Action)

        case setGenres(IdentifiedArrayOf<Genre>)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.discover, action: /Action.discover) {
            DiscoverFeature()
        }

        Scope(state: \.search, action: /Action.search) {
            SearchFeature()
        }
        
        Scope(state: \.watchlist, action: /Action.watchlist) {
            WatchlistFeature()
        }
        
        Reduce { state, action in
            switch action {
                
            case let .discover(.onMovieTap(movie)), let .search(.onMovieTap(movie)):
//                state.destination = .presentedMovie(MovieFeature.State(movieDetails: .init(movie: movie)))
                return .none
                
            case let .discover(.onMoviesListTap(listType, movies)):
//                let moviesListState = MoviesListFeature.State(listType: listType, movies: movies)
//                state.path.append(.moviesList(moviesListState))
                return .none
                
            case let .setGenres(genres):
                state.search.genres = genres
                return .none
                
            case .discover, .search:
                return .none
            }
        }
    }
}
