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
    
    @Query private var likedMovies: [LikedMovie]
    
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
        .onFirstAppear {
            send(.setLikedMovies(likedMovies))
        }
        .onChange(of: likedMovies) { _, newValue in
            send(.setLikedMovies(likedMovies))
        }
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
    
    @ViewBuilder @MainActor
    private func ContentView() -> some View {
        List(store.likedMovies) { movie in
            MovieListButton(
                movie: movie,
                onMovieTap: { send(.onMovieTap($0)) },
                onLikeTap: { send(.onMovieDislike($0)) }
            )
            .padding()
            .frame(height: 200)
            .listRowInsets(.zero)
            .listRowBackground(Color.clear)
            .listSectionSeparator(.hidden, edges: .top)
        }
        .listStyle(.grouped)
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder @MainActor
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
