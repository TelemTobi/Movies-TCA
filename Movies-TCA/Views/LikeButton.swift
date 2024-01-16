//
//  LikeButton.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 14/01/2024.
//

import SwiftUI
import Pow

struct LikeButton: View {
    
    @Binding var isLiked: Bool
    var outlineColor: Color = .white.opacity(0.8)
    
    var body: some View {
        Button(
            action: { isLiked.toggle() },
            label: {
                ZStack {
                    Image(systemName: "heart.fill")
                        .imageScale(.large)
                        .foregroundStyle(isLiked ? .red : .white.opacity(0.5))
                    
                    if !isLiked {
                        Image(systemName: "heart")
                            .imageScale(.large)
                            .foregroundStyle(outlineColor)
                    }
                }
            }
        )
        .buttonStyle(.plain)
        .changeEffect(
            .spray(layer: .named(Constants.Layer.like)) {
                Image(systemName: "heart.fill")
                    .foregroundStyle(.red)
            },
            value: isLiked,
            isEnabled: isLiked
        )
    }
}

#Preview {
    return LikeButton(isLiked: .constant(false))
        .background(.black)
}
