//
//  RootNavigator.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 04/03/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RootNavigator {
    
    @ObservableState
    struct State: Equatable {
        var destination: Destination.State = .splash(SplashFeature.State())
    }
    
    enum Action {
        case destination(Destination.Action)

//        case loadGenres
//        case genresResponse(Result<GenresResponse, TmdbError>)
    }
    
//    @Dependency(\.tmdbClient) var tmdbClient
    
    var body: some ReducerOf<Self> {
        Scope(state: \.destination, action: \.destination, child: Destination.init)
        
        Reduce { state, action in
            switch action {
//            case .view(.onFirstAppear):
//                return .send(.loadGenres)
//                
//            case .loadGenres:
//                return .run { send in
//                    let genresResult = await tmdbClient.fetchGenres()
//                    await send(.genresResponse(genresResult))
//                }
//                
//            case let .genresResponse(.success(response)):
//                state.isLoading = false
//                
//                if let genres = response.genres, genres.isNotEmpty {
//                    return .send(.home(.setGenres(IdentifiedArray(uniqueElements: genres))))
//                } else {
//                    return .send(.genresResponse(.unknownError))
//                }
//                
//            case let .genresResponse(.failure(error)):
//                state.isLoading = false
//                
//                customDump(error) // TODO: Handle error
//                return .none
                
                
            case .destination:
                return .none
            }
        }
    }
}

extension RootNavigator {
    
    @Reducer
    struct Destination {
        enum State: Equatable {
            case splash(SplashFeature.State)
            case home(HomeFeature.State)
        }
        
        enum Action {
            case splash(SplashFeature.Action)
            case home(HomeFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.splash, action: \.splash, child: SplashFeature.init)
            Scope(state: \.home, action: \.home, child: HomeFeature.init)
        }
    }
}
