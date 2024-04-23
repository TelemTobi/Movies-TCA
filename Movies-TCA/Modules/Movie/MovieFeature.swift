//
//  MovieFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 24/11/2023.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MovieFeature {
    
    @ObservableState
    struct State: Equatable {
        var movieDetails: MovieDetails
        
        @Shared(.likedMovies) 
        fileprivate var likedMovies: IdentifiedArrayOf<Movie> = []
        
        init(movieDetails: MovieDetails) {
            self.movieDetails = movieDetails
        }
        
        var isLiked: Bool {
            likedMovies.contains(movieDetails.movie)
        }
    }
    
    enum Action: ViewAction, Equatable {
        @CasePathable
        enum View: Equatable {
            case onFirstAppear
            case onCloseButtonTap
            case onRelatedMovieTap(Movie)
            case onMovieLike
        }
        
        @CasePathable
        enum Navigation: Equatable {
            case pushRelatedMovie(Movie)
            case dismissFlow
        }
        
        case view(View)
        case navigation(Navigation)
        case loadExtendedDetails
        case movieDetailsLoaded(Result<MovieDetails, TmdbError>)
    }
    
    @Dependency(\.tmdbClient) var tmdbClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return reduceViewAction(&state, viewAction)
                
            case .loadExtendedDetails:
                let movieId = state.movieDetails.movie.id
                
                return .run { send in
                    let result = await tmdbClient.movieDetails(movieId)
                    await send(.movieDetailsLoaded(result))
                }
                
            case let .movieDetailsLoaded(.success(response)):
                state.movieDetails = response
                return .none
                
            case let .movieDetailsLoaded(.failure(error)):
                customDump(error) // TODO: Handle error
                return .none
                
            case .navigation:
                return .none
            }
        }
    }
    
    private func reduceViewAction(_ state: inout State, _ action: Action.View) -> Effect<Action> {
        switch action {
        case .onFirstAppear:
            return .send(.loadExtendedDetails)
            
        case .onCloseButtonTap:
            return .send(.navigation(.dismissFlow))
            
        case let .onRelatedMovieTap(movie):
            return .send(.navigation(.pushRelatedMovie(movie)))
            
        case .onMovieLike:
            let movie = state.movieDetails.movie
            
            if state.likedMovies.contains(movie) {
                state.likedMovies.remove(movie)
            } else {
                state.likedMovies.append(movie)
            }
            return .none
        }
    }
}
