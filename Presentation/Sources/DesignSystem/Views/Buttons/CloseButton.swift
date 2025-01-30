//
//  CloseButton.swift
//  Presentation
//
//  Created by Telem Tobi on 21/01/2024.
//

import SwiftUI
import Core

public struct CloseButton: View {
    
    public var backgroundOpacity: CGFloat = 1
    public let action: EmptyClosure
    
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
