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
    
    private var preferredColorScheme: ColorScheme {
        switch Config.UserPreferences.appearance {
        case .system: colorScheme
        case .light: ColorScheme.light
        case .dark: ColorScheme.dark
        }
    }
    
    var body: some View {
        WithViewStore(store, observe: \.isLoading) { viewStore in
            Group {
                if viewStore.state {
                    SplashView()
                        .onFirstAppear {
                            viewStore.send(.onFirstAppear)
                        }
                } else {
                    HomeView(
                        store: store.scope(
                            state: \.home,
                            action: { .home($0) }
                        )
                    )
                }
            }
            .animation(.easeInOut, value: viewStore.state)
            .preferredColorScheme(preferredColorScheme)
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
