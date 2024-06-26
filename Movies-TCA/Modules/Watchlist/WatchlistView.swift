//
//  WatchlistView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 06/12/2023.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

@ViewAction(for: WatchlistFeature.self)
struct WatchlistView: View {
    
    @Bindable var store: StoreOf<WatchlistFeature>
    
    var body: some View {
        Group {
            if store.likedMovies.isEmpty {
                EmptyFavoritesView()
            } else {
                ContentView()
            }
        }
        .navigationTitle("Watchlist")
        .toolbar(content: toolbarContent)
        .alert($store.scope(state: \.alert, action: \.alert))
    }
    
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(
                action: { send(.onPreferencesTap) },
                label: {
                    Image(systemName: "gear")
                        .foregroundColor(.accentColor)
                }
            )
        }
    }
    
    @MainActor
    @ViewBuilder
    private func ContentView() -> some View {
        List(store.likedMovies) { movie in
            Button {
                send(.onMovieTap(movie))
            } label: {
                MovieListItem(
                    movie: movie,
                    isLiked: .init(
                        get: { true },
                        set: { _ in send(.onMovieDislike(movie)) }
                    )
                )
            }
            .buttonStyle(.plain)
            .listRowInsets(.zero)
            .listRowBackground(Color.clear)
            .listSectionSeparator(.hidden, edges: .top)
        }
        .listStyle(.grouped)
        .scrollIndicators(.hidden)
    }
    
    @MainActor
    @ViewBuilder
    private func EmptyFavoritesView() -> some View {
        ContentUnavailableView(
            "Your watchlist is empty",
            systemImage: "popcorn",
            description: Text("Movies you liked will appear here")
        )
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
