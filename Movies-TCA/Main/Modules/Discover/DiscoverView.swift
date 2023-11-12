//
//  DiscoverView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 11/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct DiscoverView: View {
    
    let store: StoreOf<Discover>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .onFirstAppear {
                    viewStore.send(.onFirstAppear)
                }
        }
    }
}

#Preview {
    DiscoverView(
        store: .init(
            initialState: Discover.State(),
            reducer: { Discover() }
        )
    )
}
