//
//  Config.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 14/11/2023.
//

import Foundation
import SwiftUI

enum Config {
    
    enum Key: String {
        case tmdbBaseUrl
        case tmdbAccessToken
        case tmdbPhotoBaseUrl
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
        
        static var accessToken: String {
            value(for: .tmdbAccessToken) ?? ""
        }
        
        static var photoBaseUrl: String {
            value(for: .tmdbPhotoBaseUrl) ?? ""
        }
    }
    
    enum Language: String {
        
        case english = "en"
        case hebrew = "he"
        
        var locale: Locale {
            return switch self {
            case .english: Locale(identifier: "en_US")
            case .hebrew: Locale(identifier: "he_IS")
            }
        }
        
        static var current: Language {
            let currentLocale = Locale.current.identifier.split(separator: "_").first?.lowercased() ?? ""
            return Language(rawValue: currentLocale) ?? .english
        }
    }
    
    enum ColorScheme: String, CaseIterable {
        case system = "System"
        case light = "Light"
        case dark = "Dark"
        
//        var value: SwiftUI.ColorScheme {
//            return switch self {
//            case .system: .default
//            case .light: .light
//            case .dark: .dark
//            }
//        }
    }
    
    enum UserPreferences {
        
        static var isAdultContentOn: Bool {
            get { UserDefaults.standard.bool(forKey: #function) }
            set { UserDefaults.standard.set(newValue, forKey: #function) }
        }
        
        static var colorScheme: ColorScheme {
            get { ColorScheme(rawValue: UserDefaults.standard.string(forKey: #function) ?? "") ?? .system }
            set { UserDefaults.standard.set(newValue.rawValue, forKey: #function) }
        }
    }
}
