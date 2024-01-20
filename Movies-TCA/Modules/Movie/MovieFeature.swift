//
//  MovieFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 24/11/2023.
//

import Foundation
import ComposableArchitecture

struct MovieFeature: Reducer {
    
    struct State: Equatable {
        var movieDetails: MovieDetails
    }
    
    enum Action: Equatable {
        case onFirstAppear
        case onCloseButtonTap
        case onRelatedMovieTap(Movie)
        case onLikeTap(Movie)
        
        case loadExtendedDetails
        case movieDetailsLoaded(Result<MovieDetails, TmdbError>)
    }
    
    @Dependency(\.tmdbClient) var tmdbClient
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onFirstAppear:
                return .send(.loadExtendedDetails)
                
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
                
            // MARK: Handled in parent feature
            case .onCloseButtonTap, .onRelatedMovieTap, .onLikeTap:
                return .none
            }
        }
    }
}
