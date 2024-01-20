//
//  WatchlistView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 06/12/2023.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

struct WatchlistView: View {
    
    let store: StoreOf<WatchlistFeature>
    
    @Query var likedMovies: [LikedMovie]
    
    var body: some View {
        NavigationStack {
            WithViewStore(store, observe: { $0 }) { viewStore in
                List(likedMovies) { likedMovie in
                    Text(likedMovie.title ?? .notAvailable)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
                .listStyle(.grouped)
            }
            .navigationTitle("Watchlist")
            .toolbar(content: toolbarContent)
        }
    }
    
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                store.send(.onPreferencesTap)
            } label: {
                Image(systemName: "gear")
                    .foregroundColor(.accentColor)
            }
        }
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
