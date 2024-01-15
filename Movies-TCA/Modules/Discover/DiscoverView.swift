//
//  DiscoverView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 11/11/2023.
//

import SwiftUI
import ComposableArchitecture
import Pow

struct DiscoverView: View {
    
    let store: StoreOf<DiscoverFeature>
    
    var body: some View {
        NavigationStackStore(store.scope(state: \.path, action: { .path($0) })) {
            WithViewStore(store, observe: { $0 }) { viewStore in
                ZStack {
                    if viewStore.isLoading {
                        ProgressView()
                    } else {
                        GeometryReader { geometry in
                            ContentView(geometry: geometry)
                                .environmentObject(viewStore)
                        }
                    }
                }
                .navigationTitle("Discovery")
                .animation(.easeInOut, value: viewStore.isLoading)
                .onFirstAppear {
                    viewStore.send(.onFirstAppear)
                }
            }
            .toolbar(content: toolbarContent)
            
        } destination: { state in
            switch state {
            case .moviesList:
                CaseLet(
                    /DiscoverFeature.Path.State.moviesList,
                    action: DiscoverFeature.Path.Action.moviesList,
                    then: MoviesListView.init(store:)
                )
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

extension DiscoverView {
    
    private struct ContentView: View {

        @EnvironmentObject private var viewStore: ViewStoreOf<DiscoverFeature>
        
        let geometry: GeometryProxy
        
        var body: some View {
            List {
                ForEach(MoviesListType.allCases, id: \.self) { listType in
                    if let movies = viewStore.movies[listType] {
                        SectionView(
                            listType: listType,
                            movies: movies,
                            geometry: geometry
                        )
                        .environmentObject(viewStore)
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
    }

    private struct SectionView: View {
        
        @EnvironmentObject private var viewStore: ViewStoreOf<DiscoverFeature>
        
        let listType: MoviesListType
        let movies: IdentifiedArrayOf<Movie>
        let geometry: GeometryProxy
        
        var body: some View {
            Section {
                switch listType {
                case .nowPlaying:
                    MoviesPagerView(movies: movies) {
                        viewStore.send(.onMovieTap($0))
                    }
                    .frame(height: geometry.size.width / 1.6)
                    
                case .popular, .topRated, .upcoming:
                    MoviesCollectionView(
                        movies: movies,
                        onMovieTap: { viewStore.send(.onMovieTap($0)) }
                    )
                    .frame(height: geometry.size.width * 0.7)
                }
            } header: {
                if listType != .nowPlaying {
                    SectionHeader(
                        title: listType.title,
                        action: "See All",
                        onActionTap: {
                            viewStore.send(.onMoviesListTap(listType, movies))
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
