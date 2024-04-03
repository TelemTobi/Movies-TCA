//
//  PreferencesDependency.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 30/03/2024.
//

import Foundation
import Dependencies
import SwiftUI

struct Preferences {
    
    enum Key {
        static var isAdultContentOn: String { #function }
        static var appearance: String { #function }
    }
    
    let getIsAdultContentOn: () -> Bool
    let setIsAdultContentOn: (Bool) -> Void
    
    let getAppearance: () -> String
    let setAppearance: (String) -> Void
}

extension Preferences: DependencyKey {
    
    static let liveValue = Preferences(
        getIsAdultContentOn: {
            UserDefaults.standard.bool(forKey: Key.isAdultContentOn)
        },
        setIsAdultContentOn: { isOn in
            UserDefaults.standard.setValue(isOn, forKey: Key.isAdultContentOn)
        },
        getAppearance: {
            UserDefaults.standard.string(forKey: Key.appearance) ?? Appearance.system.rawValue
        },
        setAppearance: { appearance in
            UserDefaults.standard.setValue(appearance, forKey: Key.appearance)
        }
    )
    
    static let testValue = Preferences(
        getIsAdultContentOn: { false },
        setIsAdultContentOn: { _ in },
        getAppearance: { Appearance.system.rawValue },
        setAppearance: { _ in }
    )
}

extension DependencyValues {
    var preferences: Preferences {
        get { self[Preferences.self] }
        set { self[Preferences.self] = newValue }
    }
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
    }
}
