//
//  SearchSuggestionsView.swift
//  Presentation
//
//  Created by Telem Tobi on 14/02/2025.
//

import SwiftUI
import Core
import Models
import DesignSystem

extension SearchView {
    
    @ViewBuilder
    func suggestionsView() -> some View {
        List {
            genresCapsulesSection()
            
            if store.recentlyViewed.isNotEmpty {
                recentlyViewedSection()
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    private func genresCapsulesSection() -> some View {
        let delays = Array(0..<store.genres.count)
            .map { 0.2 + (CGFloat($0) * 0.05) }
            .shuffled()
        
        Section {
            SectionHeader(title: .localized(.categories))
                .listRowSeparator(.hidden)
            
            CapsulesView(items: store.genres) { index, genre in
                Button(
                    action: {
                        send(.onGenreTap(genre))
                    },
                    label: {
                        Text(genre.description)
                            .font(.rounded(.footnote))
                            .fontWeight(.medium)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 6)
                    }
                )
                .buttonStyle(.glass)
                .opacity(didFirstAppear ? 1 : 0)
                .scaleEffect(didFirstAppear ? 1 : 0.7)
                .rotationEffect(.degrees(didFirstAppear ? 0 : 10))
                .animation(
                    .easeInOut(duration: 0.25).delay(delays[index]),
                    value: didFirstAppear
                )
            }
        }
        .listSectionSeparator(.hidden)
        .listRowBackground(Color.clear)
        .onFirstAppear {
            withAnimation { didFirstAppear = true }
        }
    }
    
    @ViewBuilder
    private func recentlyViewedSection() -> some View {
        Section {
            SectionHeader(title: .localized(.recentlyViewed))
                .listRowSeparator(.hidden)
            
            ForEach(store.recentlyViewed) { movie in
                Button {
                    send(.onMovieTap(movie))
                } label: {
                    MovieListItem(
                        movie: movie,
                        imageType: .backdrop
                    )
                }
                .buttonStyle(.plain)
                .frame(height: 70)
                .mediaContextMenu(
                    movie,
                    goToMedia: { send(.onMovieTap(movie)) },
                    shareMedia: {},
                    removeFromRecents: { send(.onRemoveFromRecents(movie)) }
                )
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        send(.onRemoveFromRecents(movie))
                    } label: {
                        Image(systemName: "trash.fill")
                    }
                }
            }
        }
        .listRowBackground(Color.clear)
        .listSectionSeparator(.hidden, edges: .bottom)
        .alignmentGuide(.listRowSeparatorLeading) { _ in
            70 * Constants.ImageType.backdrop.ratio
        }
    }
}
