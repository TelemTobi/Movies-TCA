//
//  SplashView.swift
//  Presentation
//
//  Created by Telem Tobi on 12/11/2023.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

@ViewAction(for: SplashFeature.self)
public struct SplashView: View {
    
    public let store: StoreOf<SplashFeature>
    
    public init(store: StoreOf<SplashFeature>) {
        self.store = store
    }
    
    public var body: some View {
        GeometryReader { geometry in
            Image("splashLogo")
                .resizable()
                .scaledToFit()
                .frame(width: geometry.size.width / 2)
                .position(
                    x: geometry.frame(in: .local).midX,
                    y: geometry.frame(in: .local).midY
                )
        }
        .onAppear { send(.onAppear) }
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
