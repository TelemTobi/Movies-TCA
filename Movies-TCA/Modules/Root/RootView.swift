//
//  RootView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 14/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    
    let store: StoreOf<RootFeature>
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Group {
            if store.isLoading {
                SplashView()
                    .onFirstAppear {
                        store.send(.onFirstAppear)
                    }
            } else {
                HomeView(
                    store: store.scope(state: \.home, action: \.home)
                )
            }
        }
        .animation(.easeInOut, value: store.isLoading)
        .adjustPreferredColorScheme()
        .onFirstAppear {
            Preferences.Appearance.systemColorScheme = colorScheme
        }
    }
}

#Preview {
    RootView(
        store: Store(
            initialState: RootFeature.State(),
            reducer: { RootFeature() }
        )
    )
}
