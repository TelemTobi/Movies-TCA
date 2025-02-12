//
//  MoviesHomepageView.swift
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

@ViewAction(for: MoviesHomepage.self)
public struct MoviesHomepageView: View {
    
    public let store: StoreOf<MoviesHomepage>
        
    public init(store: StoreOf<MoviesHomepage>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            switch store.viewState {
            case .loading:
                ProgressView()
                
            case let .loaded(lists):
                contentView(lists)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationTitle(.localized(.movies))
        .navigationBarTitleDisplayMode(.inline)
        .animation(.smooth, value: store.viewState)
        .backgroundColor(.background)
        .onFirstAppear { send(.onFirstAppear) }
    }
    
    @ViewBuilder
    private func contentView(_ lists: [MovieListType: IdentifiedArrayOf<Movie>]) -> some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(MovieListType.allCases, id: \.self) { listType in
                    switch listType {
                    case .watchlist:
                        if store.watchlist.isNotEmpty {
                            sectionView(listType: .watchlist, movies: store.watchlist)
                        }
                        
                    default:
                        if let movies = lists[listType], movies.isNotEmpty {
                            sectionView(listType: listType, movies: movies)
                        }
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .particleLayer(name: Constants.Layer.like)
    }
    
    @ViewBuilder
    private func sectionView(listType: MovieListType, movies: IdentifiedArrayOf<Movie>) -> some View {
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
                
            case .watchlist, .upcoming, .popular, .topRated:
                MoviesRow(
                    movies: movies,
                    listType: listType,
                    onMovieTap: { send(.onMovieTap($0, .collection)) }
                )
            }
        }
    }
}


#Preview {
    NavigationStack {
        MoviesHomepageView(
            store: Store(
                initialState: MoviesHomepage.State(),
                reducer: { MoviesHomepage() }
            )
        )
    }
}
