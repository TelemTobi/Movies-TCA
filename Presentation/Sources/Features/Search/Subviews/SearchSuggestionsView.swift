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
            CapsulesView(items: store.genres) { index, genre in
                Button(
                    action: {
                        send(.onGenreTap(genre))
                    },
                    label: {
                        Text(genre.description)
                            .font(.rounded(.footnote))
                            .fontWeight(.medium)
                    }
                )
                .buttonStyle(.capsuled)
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
                .contextMenu {
                    contextMenu(for: movie)
                } preview: {
                    MovieGridItem(
                        movie: movie,
                        imageType: .backdrop
                    )
                    .padding()
                    .frame(width: 280)
                }
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
    
    @ViewBuilder
    private func contextMenu(for movie: Movie) -> some View {
        Button(role: .destructive) {
            send(.onRemoveFromRecents(movie))
        } label: {
            Label("Remove from Recent", systemImage: "x.circle")
        }
        
        Divider()
        
        Button {
            send(.onMovieTap(movie))
        } label: {
            Label("Go to Movie", systemImage: "info.circle")
        }
        
        Button {
            
        } label: {
            Label("Share", systemImage: "square.and.arrow.up")
        }
    }
}
