//
//  AdaptiveConstrast.swift
//  Presentation
//
//  Created by Telem Tobi on 13/02/2025.
//

import SwiftUI

public enum AdaptiveConstrastShadow {
    case on(radius: CGFloat)
    case off
}

fileprivate struct AdaptiveConstrast<S: InsettableShape>: ViewModifier {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let shape: S
    let shadow: AdaptiveConstrastShadow
    
    func body(content: Content) -> some View {
        switch colorScheme {
        case .light:
            if case let .on(radius) = shadow {
                content
                    .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.15), radius: radius)
            } else {
                content
            }
            
        case .dark:
            content
                .overlay {
                    shape
                        .strokeBorder(.ultraThinMaterial, lineWidth: 1)
                }
            
        @unknown default:
            content
        }
    }
}

public extension View {
    func adaptiveConstrast<S: InsettableShape>(
        shape: S = .rect(cornerRadius: 10),
        shadow: AdaptiveConstrastShadow = .on(radius: 10)
    ) -> some View {
        modifier(AdaptiveConstrast(shape: shape, shadow: shadow))
    }
}
