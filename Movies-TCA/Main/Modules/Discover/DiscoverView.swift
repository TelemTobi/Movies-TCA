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
        NavigationStack {
            WithViewStore(store, observe: { $0 }) { viewStore in
                ZStack {
                    if viewStore.isLoading {
                        ProgressView()
                    } else {
                        List {
                            ForEach(MoviesList.ListType.allCases, id: \.self) { sectionType in
                                if let movies = viewStore.movies[sectionType] {
                                    makeSection(for: sectionType, movies: movies)
                                        .listRowInsets(.zero)
                                        .listRowSeparator(.hidden)
                                        .listRowBackground(Color.clear)
                                        .listSectionSeparator(.hidden, edges: .top)
                                }
                            }
                        }
                        .listStyle(.grouped)
                    }
                }
                .animation(.easeInOut, value: viewStore.isLoading)
                .onFirstAppear {
                    viewStore.send(.onFirstAppear)
                }
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
    
    @ViewBuilder
    private func makeSection(for section: MoviesList.ListType, movies: IdentifiedArrayOf<Movie>) -> some View {
        Section {
            switch section {
            case .nowPlaying:
                MoviesPagerView(movies: movies)
                
            case .popular, .topRated, .upcoming:
                EmptyView()
            }
        } header: {
            SectionHeader(title: section.title, action: "See All") {
                EmptyView()
                    .navigationTitle(section.title)
            }
            .padding()
            .textCase(.none)
        }
    }
}

#Preview {
    DiscoverView(
        store: .init(
            initialState: DiscoverFeature.State(),
            reducer: { DiscoverFeature() }
        )
    )
}
