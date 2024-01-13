//
//  SplashView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 12/11/2023.
//

import SwiftUI

struct SplashView: View {
    
    var body: some View {
        GeometryReader { geometry in
            Image(.splashLogo)
                .resizable()
                .scaledToFit()
                .frame(width: geometry.size.width / 2)
                .position(
                    x: geometry.frame(in: .local).midX,
                    y: geometry.frame(in: .local).midY
                )
        }
    }
}

#Preview {
    SplashView()
}
