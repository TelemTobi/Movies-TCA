//
//  AppFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 12/11/2023.
//

import Foundation
import ComposableArchitecture

struct AppReducer: Reducer {
    
    struct State: Equatable {
        var isLoading = true
        var home = Home.State()
    }
    
    enum Action: Equatable {
        case onFirstAppear
        case genresLoaded([Genre])
        case home(Home.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onFirstAppear:
                return .run { send in
                    var request = URLRequest(
                        url: .init(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=99090e29e8bdefea91a422c1d35f8204")!
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
