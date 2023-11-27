//
//  DiscoverView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 11/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct DiscoverView: View {
    
    let store: StoreOf<DiscoverFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                if viewStore.isLoading {
                    ProgressView()
                } else {
                    GeometryReader { geometry in
                        FeedView(
                            movies: viewStore.movies,
                            geometry: geometry
                        )
                        .environmentObject(viewStore)
                    }
                }
            }
            .navigationTitle("Discover")
            .toolbar(content: toolbarContent)
            .animation(.easeInOut, value: viewStore.isLoading)
            .onFirstAppear {
                viewStore.send(.onFirstAppear)
            }
            .fullScreenCover(
                store: store.scope(
                    state: \.$movie,
                    action: { .movie($0) }
                ),
                content: { movieStore in
                    MovieSheet(
                        viewStore: viewStore,
                        movieStore: movieStore
                    )
                }
            )
        }
    }
    
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .foregroundColor(.accentColor)
            }
        }
    }
    
    @MainActor
    private func MovieSheet(viewStore: ViewStoreOf<DiscoverFeature>, movieStore: StoreOf<MovieFeature>) -> some View {
        NavigationStack {
            MovieView(store: movieStore)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Close", systemImage: "xmark") {
                            viewStore.send(.onCloseMovieTap)
                        }
                    }
                }
        }
    }
}

private struct FeedView: View {

    @EnvironmentObject var viewStore: ViewStoreOf<DiscoverFeature>
    
    let movies: [MoviesList.ListType: IdentifiedArrayOf<Movie>]
    let geometry: GeometryProxy
    
    var body: some View {
        List {
            ForEach(MoviesList.ListType.allCases, id: \.self) { sectionType in
                if let movies = movies[sectionType] {
                    makeSection(
                        for: sectionType,
                        movies: movies,
                        geometry: geometry,
                        onSeeAllTap: {
                            viewStore.send(.onMoviesListTap(sectionType, movies))
                        },
                        onMovieTap: { movie in
                            viewStore.send(.onMovieTap(movie))
                        }
                    )
                }
            }
            .listRowInsets(.zero)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listSectionSeparator(.hidden, edges: .top)
        }
        .listStyle(.grouped)
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    private func makeSection(for section: MoviesList.ListType, movies: IdentifiedArrayOf<Movie>, geometry: GeometryProxy, onSeeAllTap: @escaping EmptyClosure, onMovieTap: @escaping (Movie) -> Void) -> some View {
        
        Section {
            switch section {
            case .nowPlaying:
                MoviesPagerView(movies: movies, onMovieTap: onMovieTap)
                    .frame(height: geometry.size.width / 1.6)
                
            case .popular, .topRated, .upcoming:
                MoviesCollectionView(movies: movies, onMovieTap: onMovieTap)
                    .frame(height: geometry.size.width * 0.7)
            }
        } header: {
            if section != .nowPlaying {
                SectionHeader(
                    title: section.title,
                    action: "See All",
                    onActionTap: onSeeAllTap
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
