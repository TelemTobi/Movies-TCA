//
//  PreferredAppearance.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 03/04/2024.
//

import SwiftUI
import ComposableArchitecture

fileprivate struct PreferredAppearanceModifier: ViewModifier {
    
    @Shared(.appearance) var appearance = .system
    
    func body(content: Content) -> some View {
        let colorScheme: ColorScheme? = switch appearance {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
        
        content
            .preferredColorScheme(colorScheme)
    }
}

extension View {
    
    func adjustPreferredAppearance() -> some View {
        modifier(PreferredAppearanceModifier())
    }
}
