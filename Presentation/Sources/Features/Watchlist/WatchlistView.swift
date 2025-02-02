//
//  WatchlistView.swift
//  Presentation
//
//  Created by Telem Tobi on 06/12/2023.
//

import SwiftUI
import SwiftData
import ComposableArchitecture
import Core
import DesignSystem
import Models

@ViewAction(for: Watchlist.self)
public struct WatchlistView: View {
    
    @Bindable public var store: StoreOf<Watchlist>
    
    public init(store: StoreOf<Watchlist>) {
        self.store = store
    }
    
    public var body: some View {
        Group {
            if store.watchlist.isEmpty {
                EmptyFavoritesView()
            } else {
                ContentView()
            }
        }
        .navigationTitle(.localized(.watchlist))
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
            .localized(.watchlistEmptyStateTitle),
            systemImage: "popcorn",
            description: Text(.localized(.watchlistEmptyStateContent))
        )
    }
}

extension AlertState where Action == Watchlist.Action.Alert {
    static func dislikeConfirmation(for movie: Movie) -> Self {
        Self(
            title: {
                TextState(String.localized(.areYouSure))
            },
            actions: {
                ButtonState(role: .destructive, action: .confirmDislike(movie)) {
                    TextState(.localized(.remove))
                }
                
                ButtonState(role: .cancel) {
                    TextState(String.localized(.cancel))
                }
            },
            message: {
                TextState(.localized(.watchlistRemovalAlertContent(movieTitle: movie.title ?? .empty)))
            }
        )
    }
}

#Preview {
    NavigationStack {
        WatchlistView(
            store: Store(
                initialState: Watchlist.State(),
                reducer: { Watchlist() }
            )
        )
    }
}
