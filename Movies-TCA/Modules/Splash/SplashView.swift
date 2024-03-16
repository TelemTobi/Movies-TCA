//
//  SplashView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 12/11/2023.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: SplashFeature.self)
struct SplashView: View {
    
    let store: StoreOf<SplashFeature>
    
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
    SplashView(
        store: Store(
            initialState: SplashFeature.State(),
            reducer: SplashFeature.init
        )
    )
}
