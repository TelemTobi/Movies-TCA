//
//  TmdbEndpoint.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 17/11/2023.
//

import Foundation
import Flux

enum TmdbEndpoint {
    case listGenres
    case listMovies(type: MoviesListType)
    case searchMovies(query: String)
    case discoverMovies(genreId: Int)
    case movieDetails(id: Int)
}

extension TmdbEndpoint: Endpoint {
    
    var baseURL: URL {
        URL(string: Config.TmdbApi.baseUrl)!
    }
    
    var path: String {
        return switch self {
        case .listGenres: "/genre/movie/list"
        case .listMovies(let type): "/movie/\(type.rawValue.snakeCased)"
        case .searchMovies: "/search/movie"
        case .discoverMovies: "/discover/movie"
        case .movieDetails(let id): "/movie/\(id)"
        }
    }
    
    var method: HttpMethod {
        return switch self {
        case .listGenres: .get
        case .listMovies: .get
        case .searchMovies: .get
        case .discoverMovies: .get
        case .movieDetails: .get
        }
    }
    
    var task: HttpTask {
        return switch self {
        case .listGenres: 
            .none
            
        case .listMovies:
            .none
            
        case .searchMovies(let query):
            .queryParameters(["query": query])
            
        case .discoverMovies(let genreId):
            .queryParameters(["with_genres": genreId.description])
            
        case .movieDetails:
            .queryParameters(["append_to_response": "credits,recommendations,similar"])
        }
    }
    
    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        .useDefaultKeys
    }
    
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        .tmdbDateDecodingStrategy
    }
    
    #if DEBUG
    var sampleData: Data? {
        return switch self {
        case .listGenres:
            Mock.listGenres.dataEncoded
            
        case .listMovies(let type):
            switch type {
            case .nowPlaying:
                Mock.nowPlayingMovies.dataEncoded
            case .popular:
                Mock.popularMovies.dataEncoded
            case .topRated:
                Mock.topRatedMovies.dataEncoded
            case .upcoming:
                Mock.upcomingMovies.dataEncoded
            }
            
        case .searchMovies:
            Mock.searchMovies.dataEncoded
            
        case .discoverMovies:
            Mock.discoverMovies.dataEncoded
            
        case .movieDetails:
            Mock.movieDetails.dataEncoded
        }
    }
    #endif
}
