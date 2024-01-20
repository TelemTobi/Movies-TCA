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
                List(viewStore.likedMovies) { movie in
                    Button(
                        action: { viewStore.send(.onMovieTap(movie)) },
                        label: {
                            MovieListItem(
                                movie: movie,
                                // TODO: Show alert before disliking
                                onLikeTap: { viewStore.send(.onMovieLike($0)) }
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
                .onFirstAppear {
                    viewStore.send(.setLikedMovies(likedMovies))
                }
                .onChange(of: likedMovies) { _, newValue in
                    viewStore.send(.setLikedMovies(likedMovies))
                }
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
