//
//  MovieFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 24/11/2023.
//

import Foundation
import ComposableArchitecture
import Models
import Domain

@Reducer
struct MovieFeature {
    
    @ObservableState
    struct State: Equatable {
        var movieDetails: MovieDetails
        
        @Shared(.watchlist) var watchlist: IdentifiedArrayOf<Movie> = []
        
        init(movieDetails: MovieDetails) {
            self.movieDetails = movieDetails
        }
        
        var isLiked: Bool {
            watchlist.contains(movieDetails.movie)
        }
    }
    
    enum Action: ViewAction, Equatable {
        @CasePathable
        enum View: Equatable {
            case onFirstAppear
            case onCloseButtonTap
            case onRelatedMovieTap(Movie)
            case onLikeTap
        }
        
        @CasePathable
        enum Navigation: Equatable {
            case pushRelatedMovie(Movie)
            case dismissFlow
        }
        
        case view(View)
        case navigation(Navigation)
        case fetchMovieDetails
        case movieDetailsResult(Result<MovieDetails, TmdbError>)
    }
    
    @Dependency(\.interactor) private var interactor
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return reduceViewAction(&state, viewAction)
                
            case .fetchMovieDetails:
                let movieId = state.movieDetails.movie.id
                
                return .run { send in
                    let result = await interactor.fetchMovieDetails(for: movieId)
                    await send(.movieDetailsResult(result))
                }
                
            case let .movieDetailsResult(result):
                switch result {
                case let .success(response):
                    state.movieDetails = response
                    return .none
                    
                case let .failure(error):
                    customDump(error) // TODO: Handle error
                    return .none
                }
                
            case .navigation:
                return .none
            }
        }
    }
    
    private func reduceViewAction(_ state: inout State, _ action: Action.View) -> Effect<Action> {
        switch action {
        case .onFirstAppear:
            return .send(.fetchMovieDetails)
            
        case .onCloseButtonTap:
            return .send(.navigation(.dismissFlow))
            
        case let .onRelatedMovieTap(movie):
            return .send(.navigation(.pushRelatedMovie(movie)))
            
        case .onLikeTap:
            let movie = state.movieDetails.movie
            
            if state.watchlist.contains(movie) {
                state.$watchlist.withLock { $0.remove(movie) }
            } else {
                state.$watchlist.withLock { $0.append(movie) }
            }
            return .none
        }
    }
}

extension DependencyValues {
    fileprivate var interactor: MovieInteractor {
        get { self[MovieInteractor.self] }
    }
}
