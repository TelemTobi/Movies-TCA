//
//  Preferences.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 10/01/2024.
//

import Foundation
import Combine
import SwiftUI

final class Preferences {
    
    static let standard = Preferences(userDefaults: .standard)
    let userDefaults: UserDefaults
    
    /// Sends through the changed key path whenever a change occurs.
    var preferencesChangedSubject = PassthroughSubject<AnyKeyPath, Never>()
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    @UserDefault("isAdultContentOn")
    var isAdultContentOn: Bool = false
    
    @UserDefault("appearance")
    var appearance: String = Appearance.system.rawValue
}

extension Preferences {
    
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
    
    enum Appearance: String, CaseIterable {
        case system = "System"
        case light = "Light"
        case dark = "Dark"
        
        static func colorScheme(systemScheme: ColorScheme) -> ColorScheme {
            return switch Appearance(rawValue: Preferences.standard.appearance) {
            case .system, .none: systemScheme
            case .light: .light
            case .dark: .dark
            }
        }
    }
}
