//
//  TagButtonStyle.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 28/11/2023.
//

import SwiftUI

struct TagButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .foregroundStyle(.white)
            .background(Color.accentColor)
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

