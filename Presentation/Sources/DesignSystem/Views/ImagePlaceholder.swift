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
            Color(resource: .placeholder)
            
            Image(systemName: "popcorn")
                .resizable()
                .scaledToFit()
                .frame(width: 40)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    TmdbImagePlaceholder()
        .frame(width: 200, height: 280)
}

