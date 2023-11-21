//
//  TmdbEndpoint.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 17/11/2023.
//

import Foundation

enum TmdbEndpoint {
    case listGenres
    case listMovies(type: MoviesList.ListType)
}

extension TmdbEndpoint: Endpoint {

    var baseURL: URL {
        URL(string: Config.TmdbApi.baseUrl)!
    }
    
    var path: String {
        return switch self {
            case .listGenres: "/genre/movie/list"
            case .listMovies(let type): "/movie/\(type.rawValue.snakeCased)"
        }
    }
    
    var method: HTTPMethod {
        return switch self {
            case .listGenres: .get
            case .listMovies: .get
        }
    }
    
    var task: HTTPTask {
        return switch self {
            case .listGenres: .requestPlain
            case .listMovies: .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return switch self {
            case .listGenres: nil
            case .listMovies: nil
        }
    }
    
    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        .useDefaultKeys
    }
    
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        .iso8601
    }
}
