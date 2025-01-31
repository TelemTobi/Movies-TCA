//
//  CloseButton.swift
//  Presentation
//
//  Created by Telem Tobi on 21/01/2024.
//

import SwiftUI
import Core

public struct CloseButton: View {
    
    let backgroundOpacity: CGFloat
    let action: EmptyClosure
    
    public init(backgroundOpacity: CGFloat = 1, action: @escaping EmptyClosure) {
        self.backgroundOpacity = backgroundOpacity
        self.action = action
    }
    
    public var body: some View {
        Button(
            action: action,
            label: {
                Image(systemName: "xmark")
                    .imageScale(.medium)
                    .foregroundStyle(Color.accentColor)
                    .background {
                        Color.white.opacity(0.5 * backgroundOpacity)
                            .frame(width: 32, height: 32)
                            .clipShape(.circle)
                    }
            }
        )
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        CloseButton(action: {})
    }
    .padding(100)
    .background { Color.secondary }
        
}
