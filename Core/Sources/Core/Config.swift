//
//  Config.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 14/11/2023.
//

import Foundation

public enum Config {
    
    public enum Key: String {
        case tmdbBaseUrl
        case tmdbAccessToken
        case tmdbPhotoBaseUrl
    }
    
    public static func value<T>(for key: Key) -> T? {
        let value = Bundle.main.object(forInfoDictionaryKey: key.rawValue)
        
        switch T.self {
        case is String.Type: return value as? T
        case is Bool.Type: return (value as? String)?.boolValue as? T
        default: return nil
        }
    }
    
    public enum TmdbApi {
        public static var baseUrl: String {
            value(for: .tmdbBaseUrl) ?? ""
        }
        
        public static var accessToken: String {
            value(for: .tmdbAccessToken) ?? ""
        }
        
        public static var photoBaseUrl: String {
            value(for: .tmdbPhotoBaseUrl) ?? ""
        }
    }
}
