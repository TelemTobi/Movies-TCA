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
    @AppStorage("appearance") var storedAppearance: String = ""
    
    func body(content: Content) -> some View {
        let _ = storedAppearance
        
        Group {
            if getAppearance() == .system {
                content
            } else {
                content
                    .preferredColorScheme(getAppearance() == .light ? .light : .dark)
            }
        }
    }
}

extension View {
    
    func adjustPreferredAppearance() -> some View {
        modifier(PreferredAppearanceModifier())
    }
}
