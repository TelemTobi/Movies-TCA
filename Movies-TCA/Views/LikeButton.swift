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
    var color: Color = .white
    
    var body: some View {
        Button(
            action: { isLiked.toggle() },
            label: {
                Image(systemName: "heart.fill")
                    .imageScale(.large)
                    .foregroundStyle(isLiked ? .red : color)
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
