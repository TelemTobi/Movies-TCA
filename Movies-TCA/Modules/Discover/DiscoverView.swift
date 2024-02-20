//
//  DiscoverView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 11/11/2023.
//

import SwiftUI
import ComposableArchitecture
import Pow

@ViewAction(for: DiscoverFeature.self)
struct DiscoverView: View {
    
    @Bindable var store: StoreOf<DiscoverFeature>
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            ZStack {
                if store.isLoading {
                    ProgressView()
                } else {
                    ContentView()
                }
            }
            .navigationTitle("Discovery")
            .animation(.easeInOut, value: store.isLoading)
            .toolbar(content: toolbarContent)
            .onFirstAppear {
                send(.onFirstAppear)
            }
            
        } destination: { store in
            switch store.case {
            case let .moviesList(store):
                MoviesListView(store: store)
            }
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
        List {
            ForEach(MoviesListType.allCases, id: \.self) { listType in
                if let movies = store.movies[listType] {
                    SectionView(listType: listType, movies: movies)
                }
            }
            .listRowInsets(.zero)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listSectionSeparator(.hidden, edges: .top)
        }
        .listStyle(.grouped)
        .scrollIndicators(.hidden)
        .particleLayer(name: Constants.Layer.like)
    }
    
    @ViewBuilder @MainActor
    private func SectionView(listType: MoviesListType, movies: IdentifiedArrayOf<Movie>) -> some View {
        Section {
            switch listType {
            case .nowPlaying:
                MoviesPagerView(
                    movies: movies,
                    onMovieTap: { send(.onMovieTap($0)) },
                    onLikeTap: { send(.onMovieLike($0)) }
                )
                .frame(height: 240)
                
            case .popular, .topRated, .upcoming:
                MoviesCollectionView(
                    movies: movies,
                    onMovieTap: { send(.onMovieTap($0)) },
                    onLikeTap: { send(.onMovieLike($0)) }
                )
                .frame(height: 280)
            }
        } header: {
            if listType != .nowPlaying {
                SectionHeader(
                    title: listType.title,
                    action: "See All",
                    onActionTap: {
                        send(.onMoviesListTap(listType, movies))
                    }
                )
                .padding(.horizontal)
                .textCase(.none)
            } else {
                EmptyView()
            }
        }
    }
}


#Preview {
    NavigationStack {
        DiscoverView(
            store: Store(
                initialState: DiscoverFeature.State(),
                reducer: { DiscoverFeature() }
            )
        )
    }
}
