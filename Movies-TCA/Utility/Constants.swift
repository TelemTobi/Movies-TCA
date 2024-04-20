//
//  Constants.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 22/11/2023.
//

import Foundation

typealias EmptyClosure = () -> Void
typealias MovieClosure = (Movie) -> Void

enum Constants {
    
    enum Environment {
        case live
        case test
        case preview
    }
    
    enum Appearance: String, CaseIterable {
        case system = "System"
        case light = "Light"
        case dark = "Dark"
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
    
    enum Stub {
        static let delay: Int = 2
    }
    
    enum Layer {
        static var like: String { #function }
    }
}
