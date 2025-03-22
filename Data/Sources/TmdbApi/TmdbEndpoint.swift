//
//  TmdbEndpoint.swift
//  TmdbApi
//
//  Created by Telem Tobi on 17/11/2023.
//

import Foundation
import Networking
import Core
import Models

enum TmdbEndpoint {
    case listGenres
    case listMovies(type: MovieListType)
    case searchMovies(query: String)
    case discoverByGenre(Genre)
    case movieDetails(id: Int)
}

extension TmdbEndpoint: Endpoint {
    
    var baseURL: URL {
        URL(string: Config.TmdbApi.baseUrl) ?? URL(string: "https://api.themoviedb.org/3")!
    }
    
    var path: String {
        switch self {
        case .listGenres: "/genre/movie/list"
        case .listMovies(let type): "/movie/\(type.rawValue.snakeCased)"
        case .searchMovies: "/search/movie"
        case .discoverByGenre: "/discover/movie"
        case .movieDetails(let id): "/movie/\(id)"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .listGenres: .get
        case .listMovies: .get
        case .searchMovies: .get
        case .discoverByGenre: .get
        case .movieDetails: .get
        }
    }
    
    var task: HttpTask {
        switch self {
        case .listGenres: 
            .none
            
        case .listMovies:
            .none
            
        case let .searchMovies(query):
            .queryParameters(["query": query])
            
        case let .discoverByGenre(genre):
            .queryParameters(["with_genres": genre.rawValue.description])
            
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
        switch self {
        case .listGenres:
            TmdbMock.listGenres.dataEncoded
            
        case .listMovies(let type):
            switch type {
            case .watchlist:
                TmdbMock.nowPlayingMovies.dataEncoded
            case .nowPlaying:
                TmdbMock.nowPlayingMovies.dataEncoded
            case .popular:
                TmdbMock.popularMovies.dataEncoded
            case .topRated:
                TmdbMock.topRatedMovies.dataEncoded
            case .upcoming:
                TmdbMock.upcomingMovies.dataEncoded
            }
            
        case .searchMovies:
            TmdbMock.searchMovies.dataEncoded
            
        case .discoverByGenre:
            TmdbMock.discoverMovies.dataEncoded
            
        case .movieDetails:
            TmdbMock.movieDetails.dataEncoded
        }
    }
    
    var shouldPrintLogs: Bool {
        false
    }
    #endif
}
