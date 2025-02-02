//
//  DiscoveryView.swift
//  Presentation
//
//  Created by Telem Tobi on 11/11/2023.
//

import SwiftUI
import ComposableArchitecture
import Pow
import Core
import Models
import DesignSystem

@ViewAction(for: Discovery.self)
public struct DiscoveryView: View {
    
    public let store: StoreOf<Discovery>
        
    public init(store: StoreOf<Discovery>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            if store.isLoading {
                ProgressView()
            } else {
                ContentView()
            }
        }
        .navigationTitle(.localized(.discovery))
        .animation(.easeInOut, value: store.isLoading)
        .toolbar(content: toolbarContent)
        .onFirstAppear {
            send(.onFirstAppear)
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
            ForEach(MovieListType.allCases, id: \.self) { listType in
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
    private func SectionView(listType: MovieListType, movies: IdentifiedArrayOf<Movie>) -> some View {
        Section {
            switch listType {
            case .nowPlaying:
                MoviesPagerView(
                    movies: movies,
                    onMovieTap: { send(.onMovieTap($0)) },
                    isMovieLiked: { movie in
                        Binding<Bool>(
                            get: { store.watchlist.contains(movie) },
                            set: { _ in send(.onMovieLike(movie)) }
                        )
                    }
                )
                .frame(height: 240)
                
            case .popular, .topRated, .upcoming:
                MoviesCollectionView(
                    movies: movies,
                    onMovieTap: { send(.onMovieTap($0)) },
                    isMovieLiked: { movie in
                        .init(
                            get: { store.watchlist.contains(movie) },
                            set: { _ in send(.onMovieLike(movie)) }
                        )
                    }
                )
                .frame(height: 280)
            }
        } header: {
            if listType != .nowPlaying {
                SectionHeader(title: listType.title) {
                    send(.onMovieListTap(listType, movies))
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
        DiscoveryView(
            store: Store(
                initialState: Discovery.State(),
                reducer: { Discovery() }
            )
        )
    }
}
