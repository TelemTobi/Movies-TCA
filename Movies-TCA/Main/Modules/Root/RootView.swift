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
                            action: RootFeature.Action.home
                        )
                    )
                }
            }
            .animation(.easeInOut, value: viewStore.state)
        }
    }
}

#Preview {
    RootView(
        store: .init(
            initialState: RootFeature.State(),
            reducer: { RootFeature() }
        )
    )
}
