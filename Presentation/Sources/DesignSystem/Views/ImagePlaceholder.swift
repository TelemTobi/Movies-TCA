//
//  ImagePlaceholder.swift
//  Presentation
//
//  Created by Telem Tobi on 31/01/2025.
//

import SwiftUI

public struct TmdbImagePlaceholder: View {
    
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

#Preview {
    TmdbImagePlaceholder()
        .frame(width: 200, height: 280)
}

