//
//  CloseButton.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 21/01/2024.
//

import SwiftUI

struct CloseButton: View {
    
    var backgroundOpacity: CGFloat = 1
    let action: EmptyClosure
    
    var body: some View {
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
