//
//  CapsuledButtonStyle.swift
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
            .background(Color.blue.gradient)
            .clipShape(.capsule)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .overlay {
                if configuration.isPressed {
                    Color(resource: .background).opacity(0.15)
                }
            }
            .overlay {
                Capsule()
                    .strokeBorder(.ultraThinMaterial, lineWidth: 1)
            }
    }
}

public extension ButtonStyle where Self == CapsuledButtonStyle {
    static var capsuled: Self { CapsuledButtonStyle() }
}
