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
        
        init(movieDetails: MovieDetails) {
            self.movieDetails = movieDetails
        }
    }
    
    enum Action: ViewAction, Equatable {
        enum View: Equatable {
            case onFirstAppear
            case onCloseButtonTap
            case onRelatedMovieTap(Movie)
            case onLikeTap(Movie)
        }
        
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
    @Dependency(\.database) var database
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return reduceViewAction(&state, viewAction)
                
            case .loadExtendedDetails:
                guard let movieId = state.movieDetails.movie.id else { return .none }
                
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
            
        case let .onLikeTap(movie):
            // TODO: Extract to a UseCase ⚠️
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
        }
    }
}
