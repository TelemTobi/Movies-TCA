//
//  ImagePlaceholder.swift
//  Presentation
//
//  Created by Telem Tobi on 31/01/2025.
//

import SwiftUI

public struct ImagePlaceholder: View {
    
    public var body: some View {
        ZStack {
            Color.gray.opacity(0.25)
            
            Image(systemName: "popcorn")
                .resizable()
                .scaledToFit()
                .frame(width: 40)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    ImagePlaceholder()
}
