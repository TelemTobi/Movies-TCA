//
//  TagButtonStyle.swift
//  Presentation
//
//  Created by Telem Tobi on 28/11/2023.
//

import SwiftUI

public struct CapsuledButtonStyle: ButtonStyle {
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .foregroundStyle(.white)
            .background(Color.accentColor.gradient)
            .clipShape(.capsule)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

public extension ButtonStyle where Self == CapsuledButtonStyle {
    static var capsuled: Self { CapsuledButtonStyle() }
}
