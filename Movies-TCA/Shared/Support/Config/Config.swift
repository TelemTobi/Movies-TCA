//
//  Config.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 14/11/2023.
//

import Foundation

enum Config {
    
    enum Key: String {
        case tmdbBaseUrl
        case tmdbApiKey
    }
    
    static func value<T>(for key: Key) -> T? {
        let value = Bundle.main.object(forInfoDictionaryKey: key.rawValue)
        
        switch T.self {
        case is String.Type: return value as? T
        case is Bool.Type: return (value as? String)?.boolValue as? T
        default: return nil
        }
    }
    
    enum TmdbApi {
        static var baseUrl: String {
            value(for: .tmdbBaseUrl) ?? ""
        }
        
        static var apiKey: String {
            value(for: .tmdbApiKey) ?? ""
        }
    }
}
