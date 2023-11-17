//
//  TmdbEndpoint.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 17/11/2023.
//

import Foundation
import Moya

enum TmdbEndpoint {
    case listGenres
}

extension TmdbEndpoint: TargetTypeEndPoint {
    
    var baseURL: URL {
        URL(string: Config.TmdbApi.baseUrl)!
    }
    
    var path: String {
        return switch self {
            case .listGenres: "/genre/movie/list"
        }
    }
    
    var method: Moya.Method {
        return switch self {
            case .listGenres: .get
        }
    }
    
    var task: Moya.Task {
        return switch self {
            case .listGenres: .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return switch self {
            case .listGenres: nil
        }
    }
    
    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        .useDefaultKeys
    }
    
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        .iso8601
    }
}
