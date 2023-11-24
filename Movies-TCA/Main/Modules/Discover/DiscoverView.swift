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
            GeometryReader { geometry in
                ZStack {
                    if viewStore.isLoading {
                        ProgressView()
                    } else {
                        FeedView(
                            movies: viewStore.movies,
                            geometry: geometry
                        )
                    }
                }
                .animation(.easeInOut, value: viewStore.isLoading)
            }
            .onFirstAppear {
                viewStore.send(.onFirstAppear)
            }
            .navigationTitle("Discover")
            .toolbar(content: toolbarContent)
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
}

private struct FeedView: View {
    
    let movies: [MoviesList.ListType: IdentifiedArrayOf<Movie>]
    let geometry: GeometryProxy
    
    var body: some View {
        List {
            ForEach(MoviesList.ListType.allCases, id: \.self) { sectionType in
                if let movies = movies[sectionType] {
                    makeSection(
                        for: sectionType,
                        movies: movies,
                        geometry: geometry
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
    private func makeSection(for section: MoviesList.ListType, movies: IdentifiedArrayOf<Movie>, geometry: GeometryProxy) -> some View {
        
        Section {
            switch section {
            case .nowPlaying:
                MoviesPagerView(movies: movies)
                    .frame(height: geometry.size.width / 1.6)
                
            case .popular, .topRated, .upcoming:
                MoviesCollectionView(movies: movies)
                    .frame(height: geometry.size.width * 0.7)
            }
        } header: {
            if section != .nowPlaying {
                SectionHeader(title: section.title, action: "See All") {
                    Color.clear
                        .navigationTitle(section.title)
                }
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
            store: .init(
                initialState: DiscoverFeature.State(),
                reducer: { DiscoverFeature() }
            )
        )
    }
}
