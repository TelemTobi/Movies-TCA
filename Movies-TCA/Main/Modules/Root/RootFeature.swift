//
//  RootFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 14/11/2023.
//

import Foundation
import ComposableArchitecture

struct Root: Reducer {
    
    struct State: Equatable {
        var isLoading = true
        var home = Home.State()
    }
    
    enum Action: Equatable {
        case onFirstAppear
        case loadGenres
        case genresLoaded([Genre])
        case home(Home.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .onFirstAppear:
                    return .send(.loadGenres)
                    
                case .loadGenres:
                    return .run { send in
                        let request = URLRequest(
                            url: .init(string: "\(Config.tmdbApi.baseUrl)/genre/movie/list")!
                                .appending(queryItems: [.init(name: "api_key", value: Config.tmdbApi.apiKey)])
                        )
                        
                        let (data, _) = try await URLSession.shared.data(for: request)
                        let response = try JSONDecoder().decode(GenresResponse.self, from: data)
                        
                        guard let genres = response.genres, genres.isNotEmpty else {
                            // TODO: Handle error
                            return
                        }
                        
                        await send(.genresLoaded(genres))
                    }
                    
                case let .genresLoaded(genres):
                    state.home.movieGenres = genres
                    state.isLoading = false
                    return .none
                    
                case .home:
                    return .none
            }
        }
    }
}

