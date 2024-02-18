//
//  HomeFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 11/11/2023.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HomeFeature {
    
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var moviePath = StackState<MoviePath.State>()
        
        var selectedTab: Tab = .discover
        var discover = DiscoverFeature.State()
        var search = SearchFeature.State()
        var watchlist = WatchlistFeature.State()
    }
    
    enum Action: ViewAction, Equatable {
        enum View: Equatable {
        }

        case view(View)
        case onTabSelection(Tab)
        case setGenres(IdentifiedArrayOf<Genre>)
        case destination(PresentationAction<Destination.Action>)
        case moviePath(StackAction<MoviePath.State, MoviePath.Action>)
        case discover(DiscoverFeature.Action)
        case search(SearchFeature.Action)
        case watchlist(WatchlistFeature.Action)
    }
    
    @Dependency(\.database) private var database
    
    var body: some ReducerOf<Self> {
        Scope(state: \.discover, action: \.discover, child: DiscoverFeature.init)
        
        Scope(state: \.search, action: \.search, child: SearchFeature.init)
        
        Scope(state: \.watchlist, action: \.watchlist, child: WatchlistFeature.init)
        
        Reduce { state, action in
            switch action {
            case let .onTabSelection(tab):
                state.selectedTab = tab
                return .none
                
            case let .setGenres(genres):
                state.search.genres = genres
                return .none
                
            case .discover(.view(.onPreferencesTap)),
                 .search(.view(.onPreferencesTap)),
                 .watchlist(.view(.onPreferencesTap)):
                
                state.destination = .preferences(PreferencesFeature.State())
                return .none
                
            case let .discover(.view(.onMovieTap(movie))),
                 let .search(.view(.onMovieTap(movie))),
                let .watchlist(.view(.onMovieTap(movie))),
                 let .discover(.path(.element(_, action: .moviesList(.onMovieTap(movie))))):
                
                state.moviePath.removeAll()
                state.destination = .movie(MovieFeature.State(movieDetails: .init(movie: movie)))
                return .none
                
            case let .discover(.view(.onMovieLike(movie))),
                 let .search(.view(.onMovieLike(movie))),
                 let .watchlist(.view(.onMovieLike(movie))),
                 let .discover(.path(.element(_, action: .moviesList(.onMovieLike(movie))))),
                 let .destination(.presented(.movie(.onLikeTap(movie)))),
                 let .moviePath(.element(_, action: .relatedMovie(.onLikeTap(movie)))):
                
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
        .ifLet(\.$destination, action: \.destination)
        .forEach(\.moviePath, action: \.moviePath)
    }
}

extension HomeFeature {
    
    @Reducer(state: .equatable, action: .equatable)
    enum Destination {
        case movie(MovieFeature)
        case preferences(PreferencesFeature)
    }
    
    @Reducer(state: .equatable, action: .equatable)
    enum MoviePath {
        case relatedMovie(MovieFeature)
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
