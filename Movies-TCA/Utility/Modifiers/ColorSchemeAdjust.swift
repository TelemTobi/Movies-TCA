//
//  AdjustColorScheme.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 10/01/2024.
//

import SwiftUI

fileprivate struct ColorSchemeAdjust: ViewModifier {
    
    @Preference(\.appearance) private var appearance
    
    private var preferredColorScheme: ColorScheme {
        switch Preferences.Appearance(rawValue: appearance) {
        case .system, .none: Preferences.Appearance.systemColorScheme
        case .light: ColorScheme.light
        case .dark: ColorScheme.dark
        }
    }
    
    func body(content: Content) -> some View {
        content
            .preferredColorScheme(preferredColorScheme)
    }
}

extension View {
    
    @MainActor
    func adjustPreferredColorScheme() -> some View {
        modifier(ColorSchemeAdjust())
    }
}
