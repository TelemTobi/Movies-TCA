//
//  WatchlistView.swift
//  Presentation
//
//  Created by Telem Tobi on 06/12/2023.
//

import SwiftUI
import SwiftData
import ComposableArchitecture
import DesignSystem
import Models

@ViewAction(for: WatchlistFeature.self)
struct WatchlistView: View {
    
    @Bindable var store: StoreOf<WatchlistFeature>
    
    var body: some View {
        Group {
            if store.watchlist.isEmpty {
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
        List(store.watchlist) { movie in
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

extension AlertState where Action == WatchlistFeature.Action.Alert {
    static func dislikeConfirmation(for movie: Movie) -> Self {
        Self(
            title: {
                TextState("Are you sure?")
            },
            actions: {
                ButtonState(role: .destructive, action: .confirmDislike(movie)) {
                    TextState("Remove")
                }
                
                ButtonState(role: .cancel) {
                    TextState("Cancel")
                }
            },
            message: {
                TextState("Your'e about to remove \(movie.title ?? "") from your watchlist")
            }
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
