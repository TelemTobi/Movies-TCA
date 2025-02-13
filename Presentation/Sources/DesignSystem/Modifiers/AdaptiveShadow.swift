//
//  AdaptiveShadow.swift
//  Presentation
//
//  Created by Telem Tobi on 13/02/2025.
//

import SwiftUI

fileprivate struct AdaptiveShadow: ViewModifier {
    
    let opacity: CGFloat
    let radius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: opacity), radius: radius)
    }
}

public extension View {
    func adaptiveShadow(opacity: CGFloat = 0.15, radius: CGFloat = 10) -> some View {
        modifier(
            AdaptiveShadow(opacity: opacity, radius: radius)
        )
    }
}
