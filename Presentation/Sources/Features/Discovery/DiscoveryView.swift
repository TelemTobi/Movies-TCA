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
        .ignoresSafeArea(edges: .top)
        .navigationTitle(.localized(.discovery))
        .navigationBarTitleDisplayMode(.inline)
        .animation(.easeInOut, value: store.isLoading)
        .backgroundColor(.background)
        .onFirstAppear {
            send(.onFirstAppear)
        }
    }
    
    @ViewBuilder
    private func ContentView() -> some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(MovieListType.allCases, id: \.self) { listType in
                    if let movies = store.movies[listType] {
                        SectionView(listType: listType, movies: movies)
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .particleLayer(name: Constants.Layer.like)
    }
    
    @ViewBuilder
    private func SectionView(listType: MovieListType, movies: IdentifiedArrayOf<Movie>) -> some View {
        VStack(spacing: 0) {
            if listType != .nowPlaying {
                SectionHeader(title: listType.title) {
                    send(.onMovieListTap(listType, movies))
                }
                .padding(.horizontal)
                .textCase(.none)
            } else {
                EmptyView()
            }
            
            switch listType {
            case .nowPlaying:
                MoviesPager(
                    movies: movies,
                    onMovieTap: { send(.onMovieTap($0, .pager)) }
                )
                .aspectRatio(14/21, contentMode: .fill)
                
            case .upcoming:
                MoviesCollectionView(
                    type: .backdrop,
                    movies: movies,
                    onMovieTap: { send(.onMovieTap($0, .collection)) }
                )
                .frame(height: 120)
                
            case .popular:
                MoviesCollectionView(
                    type: .poster,
                    movies: movies,
                    onMovieTap: { send(.onMovieTap($0, .collection)) }
                )
                .frame(height: 280)
                
            case .topRated:
                MoviesCollectionView(
                    type: .backdrop,
                    movies: movies,
                    onMovieTap: { send(.onMovieTap($0, .collection)) }
                )
                .frame(height: 140)
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
