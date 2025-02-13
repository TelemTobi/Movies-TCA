//
//  SplashView.swift
//  Presentation
//
//  Created by Telem Tobi on 12/11/2023.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

@ViewAction(for: Splash.self)
public struct SplashView: View {
    
    public let store: StoreOf<Splash>
    
    public init(store: StoreOf<Splash>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            Image(.splashLogo)
                .resizable()
                .scaledToFit()
                .frame(width: 200)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .backgroundColor(.background)
        .onAppear { send(.onAppear) }
    }
}

#Preview {
    SplashView(
        store: Store(
            initialState: Splash.State(),
            reducer: Splash.init
        )
    )
}
