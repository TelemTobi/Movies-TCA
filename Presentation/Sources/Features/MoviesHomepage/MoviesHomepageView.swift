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
                
            case let .loaded(sections):
                contentView(sections)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationTitle(.localized(.movies))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: toolbarContent)
        .animation(.smooth, value: store.viewState)
        .backgroundColor(.background)
        .onFirstAppear { send(.onFirstAppear) }
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
    
    @ViewBuilder
    private func contentView(_ sections: [HomepageSection]) -> some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(sections, id: \.self) { section in
                    sectionView(section: section)
                }
            }
            .scrollIndicators(.hidden)
            .particleLayer(name: Constants.Layer.like)
        }
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    private func sectionView(section: HomepageSection) -> some View {
        VStack(spacing: 0) {
            if let title = section.title {
                SectionHeader(
                    title: title,
                    action: section.isExpandable ? { send(.onSectionHeaderTap(section)) } : nil
                )
                .padding(.horizontal)
                .textCase(.none)
            }
            
            switch section {
            case .nowPlaying:
                MoviesPager(
                    movies: store.lists[.nowPlaying]?.movies ?? [],
                    onMovieTap: { send(.onMovieTap($0, .pager)) }
                )
                .aspectRatio(14/21, contentMode: .fill)
                
            case .watchlist, .upcoming, .popular, .topRated:
                let movies: [Movie] = switch section {
                case .watchlist: store.watchlist.elements
                case .upcoming: store.lists[.upcoming]?.movies ?? []
                case .popular: store.lists[.popular]?.movies ?? []
                case .topRated: store.lists[.topRated]?.movies ?? []
                default: []
                }
                
                MoviesRow(
                    movies: movies,
                    imageType: section.imageType,
                    itemWidth: section.itemWidth,
                    indexed: section.indexed,
                    onMovieTap: { send(.onMovieTap($0, .collection)) },
                    toggleWatchlist: { send(.toggleWatchlist($0)) }
                )
                
            case .genres:
                GenresRow(
                    genres: [.action, .scienceFiction, .comedy, .thriller, .drama],
                    onGenreTap: { send(.onGenreTap($0)) }
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
