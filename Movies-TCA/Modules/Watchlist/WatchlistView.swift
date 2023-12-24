//
//  WatchlistView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 06/12/2023.
//

import SwiftUI
import ComposableArchitecture

struct WatchlistView: View {
    
    let store: StoreOf<WatchlistFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List {
                Text("WIP")
                    .foregroundStyle(.secondary)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
            .listStyle(.grouped)
        }
        .navigationTitle("Watchlist")
    }
}

#Preview {
    NavigationStack {
        WatchlistView(
            store: Store(
                initialState: WatchlistFeature.State(),
                reducer: { WatchlistFeature() }
            )
        )
    }
}
