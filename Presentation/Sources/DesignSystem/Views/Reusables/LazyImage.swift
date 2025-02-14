//
//  LazyImage.swift
//  Presentation
//
//  Created by Telem Tobi on 14/02/2025.
//

import SwiftUI
import NukeUI

public struct LazyImage<Placeholder: View, Fallback: View>: View {
    
    let url: URL?
    @ViewBuilder let placeholder: () -> Placeholder
    @ViewBuilder let fallback: () -> Fallback
    
    public init(
        url: URL?,
        placeholder: @escaping () -> Placeholder = { Color(resource: .background) },
        fallback: @escaping () -> Fallback = { DefaultImageFallback() }
    ) {
        self.url = url
        self.placeholder = placeholder
        self.fallback = fallback
    }
    
    public var body: some View {
        NukeUI.LazyImage(url: url) { state in
            ZStack {
                if let image = state.image {
                    image.resizable()
                } else if let _ = state.error {
                    fallback()
                } else {
                    placeholder()
                }
            }
            .animation(.smooth(duration: 0.1), value: state.image)
        }
    }
}

public struct DefaultImageFallback: View {
    
    public init() {}
    
    public var body: some View {
        ZStack {
            Image(systemName: "popcorn")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 40)
                .foregroundColor(.white)
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .backgroundColor(.placeholder)
    }
}
