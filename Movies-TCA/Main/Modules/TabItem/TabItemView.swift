//
//  TabItemView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 26/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct TabItemView: View {
    
    let type: HomeFeature.Tab
    let store: StoreOf<TabItemFeature>
    
    var body: some View {
        NavigationStackStore(store.scope(state: \.path, action: { .path($0) })) {
            Group {
                switch type {
                case .discover:
                    DiscoverView(
                        store: store.scope(
                            state: \.discover,
                            action: { .discover($0) }
                        )
                    )
                    
                case .search:
                    SearchView(
                        store: store.scope(
                            state: \.search,
                            action: { .search($0) }
                        )
                    )
                    
                case .watchlist:
                    Text("Watchlist")
                }
            }
            .toolbar(content: toolbarContent)
            .fullScreenCover(
                store: store.scope(
                    state: \.$presentedMovie,
                    action: { .presentedMovie($0) }
                ),
                content: { movieStore in
                    MovieSheet(movieStore: movieStore)
                }
            )
            
        } destination: { state in
            switch state {
            case .moviesList:
                CaseLet(
                    /TabItemFeature.Path.State.moviesList,
                    action: TabItemFeature.Path.Action.moviesList,
                    then: MoviesListView.init(store:)
                )
            }
        }
    }
    
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                
            } label: {
                Image(systemName: "gear")
                    .foregroundColor(.accentColor)
            }
        }
    }
    
    @MainActor
    private func MovieSheet(movieStore: StoreOf<MovieFeature>) -> some View {
        NavigationStack {
            MovieView(store: movieStore)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Close", systemImage: "xmark") {
                            movieStore.send(.onCloseButtonTap)
                        }
                    }
                }
        }
    }
}

#Preview {
    TabItemView(
        type: .discover,
        store: Store(
            initialState: TabItemFeature.State(),
            reducer: { TabItemFeature() }
        )
    )
}
