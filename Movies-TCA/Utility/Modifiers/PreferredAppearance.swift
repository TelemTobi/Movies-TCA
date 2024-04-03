//
//  PreferredAppearance.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 03/04/2024.
//

import SwiftUI
import Dependencies

fileprivate struct PreferredAppearanceModifier: ViewModifier {
    
    @Dependency(\.preferences.getAppearance) var getAppearance
    
    func body(content: Content) -> some View {
        Group {
            if getAppearance() == Preferences.Appearance.system.rawValue {
                content
            } else {
                content
                    .preferredColorScheme(
                        getAppearance() == Preferences.Appearance.light.rawValue ? .light : .dark
                    )
            }
        }
    }
}

extension View {
    
    func adjustPreferredAppearance() -> some View {
        modifier(PreferredAppearanceModifier())
    }
}
