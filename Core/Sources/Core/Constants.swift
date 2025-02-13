//
//  Constants.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 22/11/2023.
//

import Foundation

public typealias EmptyClosure = () -> Void

public enum Constants {
    
    public enum Environment {
        case live
        case test
        case preview
    }
    
    public enum Appearance: String, CaseIterable, Sendable {
        case system
        case light
        case dark
    }
    
    public enum Language: String {
        case english = "en"
        case hebrew = "he"

        public var locale: Locale {
            return switch self {
            case .english: Locale(identifier: "en_US")
            case .hebrew: Locale(identifier: "he_IS")
            }
        }

        public static var current: Language {
            let currentLocale = Locale.current.identifier.split(separator: "_").first?.lowercased() ?? ""
            return Language(rawValue: currentLocale) ?? .english
        }
    }
    
    
    public enum ImageType {
        case poster, backdrop
        
        public var ratio: CGFloat {
            switch self {
            case .poster: 14/21
            case .backdrop: 38/21
            }
        }
    }
    
    public enum Layer {
        public static var like: String { #function }
    }
}
