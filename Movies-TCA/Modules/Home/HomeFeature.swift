//
//  HomeFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 11/11/2023.
//

import Foundation
import ComposableArchitecture

struct HomeFeature: Reducer {
    
    struct State: Equatable {
        @PresentationState var destination: Destination.State?
        var moviePath = StackState<MoviePath.State>()
        
        var selectedTab: Tab = .discover
        var discover = DiscoverFeature.State()
        var search = SearchFeature.State()
        var watchlist = WatchlistFeature.State()
    }
    
    enum Action: Equatable {
        case destination(PresentationAction<Destination.Action>)
        case moviePath(StackAction<MoviePath.State, MoviePath.Action>)
        
        case onFirstAppear
        case onTabSelection(Tab)
        case setGenres(IdentifiedArrayOf<Genre>)
        
        case discover(DiscoverFeature.Action)
        case search(SearchFeature.Action)
        case watchlist(WatchlistFeature.Action)
    }
    
    struct Destination: Reducer {
        
        enum State: Equatable {
            case movie(MovieFeature.State)
            case preferences(PreferencesFeature.State)
        }
        
        enum Action: Equatable {
            case movie(MovieFeature.Action)
            case preferences(PreferencesFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.movie, action: /Action.movie) {
                MovieFeature()
            }
            
            Scope(state: /State.preferences, action: /Action.preferences) {
                PreferencesFeature()
            }
        }
    }
    
    struct MoviePath: Reducer {
        
        enum State: Equatable {
            case relatedMovie(MovieFeature.State)
        }
        
        enum Action: Equatable {
            case relatedMovie(MovieFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.relatedMovie, action: /Action.relatedMovie) {
                MovieFeature()
            }
        }
    }
    
    @Dependency(\.database) private var database
    
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
            case .onFirstAppear:
                return .none
                
            case let .onTabSelection(tab):
                state.selectedTab = tab
                return .none
                
            case let .setGenres(genres):
                state.search.genres = genres
                return .none
                
            case .discover(.onPreferencesTap),
                 .search(.onPreferencesTap),
                 .watchlist(.onPreferencesTap):
                
                state.destination = .preferences(PreferencesFeature.State())
                return .none
                
            case let .discover(.onMovieTap(movie)),
                 let .search(.onMovieTap(movie)),
                 let .watchlist(.onMovieTap(movie)),
                 let .discover(.path(.element(_, action: .moviesList(.onMovieTap(movie))))):
                
                state.moviePath.removeAll()
                state.destination = .movie(MovieFeature.State(movieDetails: .init(movie: movie)))
                return .none
                
            case let .discover(.onMovieLike(movie)):
                if movie.isLiked {
                    let likedMovie = LikedMovie(movie)
                    try? database.context().insert(likedMovie)
                } else {
                    let movieId = movie.id
                    try? database.context().delete(
                        model: LikedMovie.self,
                        where: #Predicate { $0.id == movieId }
                    )
                }
                return .none
                
            case let .destination(.presented(.movie(.onRelatedMovieTap(movie)))),
                 let .moviePath(.element(_, action: .relatedMovie(.onRelatedMovieTap(movie)))):
                
                let movieState = MovieFeature.State(movieDetails: .init(movie: movie))
                state.moviePath.append(.relatedMovie(movieState))
                return .none
                
            case .destination(.presented(.movie(.onCloseButtonTap))),
                 .moviePath(.element(_, action: .relatedMovie(.onCloseButtonTap))):
                
                return .send(.destination(.dismiss))
                
            case .destination, .moviePath, .discover, .search, .watchlist:
                return .none
            }
        }
        .ifLet(\.$destination, action: /Action.destination) {
            Destination()
        }
        .forEach(\.moviePath, action: /Action.moviePath) {
            MoviePath()
        }
    }
}

extension HomeFeature {
    
    enum Tab {
        case discover, search, watchlist
        
        var title: String {
            return switch self {
            case .discover: "Discovery"
            case .search: "Search"
            case .watchlist: "Watchlist"
            }
        }
    }
}
