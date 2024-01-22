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
    
    @Query private var likedMovies: [LikedMovie]
    
    var body: some View {
        NavigationStack {
            WithViewStore(store, observe: { $0 }) { viewStore in
                if viewStore.likedMovies.isEmpty {
                    EmptyFavoritesView()
                } else {
                    ContentView()
                        .environmentObject(viewStore)
                }
            }
            .navigationTitle("Watchlist")
            .toolbar(content: toolbarContent)
            .alert(store: store.scope(state: \.$alert, action: { .alert($0) }))
            .onFirstAppear {
                store.send(.setLikedMovies(likedMovies))
            }
            .onChange(of: likedMovies) { _, newValue in
                store.send(.setLikedMovies(likedMovies))
            }
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

extension WatchlistView {
    private struct ContentView: View {
        
        @EnvironmentObject private var viewStore: ViewStoreOf<WatchlistFeature>
        
        var body: some View {
            List(viewStore.likedMovies) { movie in
                Button(
                    action: { viewStore.send(.onMovieTap(movie)) },
                    label: {
                        MovieListItem(
                            movie: movie,
                            onLikeTap: {
                                viewStore.send(.onMovieDislike($0))
                            }
                        )
                    }
                )
                .padding()
                .frame(height: 200)
                .buttonStyle(.plain)
                .listRowInsets(.zero)
                .listRowBackground(Color.clear)
                .listSectionSeparator(.hidden, edges: .top)
            }
            .listStyle(.grouped)
            .scrollIndicators(.hidden)
        }
    }
    
    private struct EmptyFavoritesView: View {
        
        var body: some View {
            ContentUnavailableView(
                "Your watchlist is empty",
                systemImage: "popcorn",
                description: Text("Movies you liked will appear here")
            )
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
