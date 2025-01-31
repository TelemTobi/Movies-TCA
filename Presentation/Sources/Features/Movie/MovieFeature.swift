//
//  MovieFeature.swift
//  Presentation
//
//  Created by Telem Tobi on 24/11/2023.
//

import Foundation
import ComposableArchitecture
import Models

@Reducer
public struct MovieFeature {
    
    @ObservableState
    public struct State: Equatable {
        var movieDetails: MovieDetails
        
        @Shared(.watchlist) var watchlist: IdentifiedArrayOf<Movie> = []
        
        public init(movieDetails: MovieDetails) {
            self.movieDetails = movieDetails
        }
        
        var isLiked: Bool {
            watchlist.contains(movieDetails.movie)
        }
    }
    
    public enum Action: ViewAction, Equatable {
        @CasePathable
        public enum View: Equatable {
            case onFirstAppear
            case onCloseButtonTap
            case onRelatedMovieTap(Movie)
            case onLikeTap
        }
        
        @CasePathable
        public enum Navigation: Equatable {
            case pushRelatedMovie(Movie)
            case dismissFlow
        }
        
        case view(View)
        case navigation(Navigation)
        case fetchMovieDetails
        case movieDetailsResult(Result<MovieDetails, TmdbError>)
    }
    
    @Dependency(\.interactor) private var interactor
    
    public init() {}

    public var body: some ReducerOf<Self> {
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
            return .run { _ in
                await interactor.toggleWatchlist(for: movie)
            }
        }
    }
}

extension DependencyValues {
    fileprivate var interactor: MovieInteractor {
        get { self[MovieInteractor.self] }
    }
}
