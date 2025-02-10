//
//  SearchView.swift
//  Presentation
//
//  Created by Telem Tobi on 24/11/2023.
//

import UIKit
import SwiftUI
import ComposableArchitecture
import Core
import DesignSystem
import Models

@ViewAction(for: Search.self)
public struct SearchView: View {
    
    @Bindable public var store: StoreOf<Search>
    @State private var didFirstAppear: Bool = false
    
    public init(store: StoreOf<Search>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            if store.isLoading {
                ProgressView()
            } else {
                contentView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .backgroundColor(.background)
        .animation(.snappy, value: store.isLoading)
        .navigationTitle(.localized(.search))
        .toolbar(content: toolbarContent)
        .searchable(
            text: $store.searchInput.sending(\.onInputChange),
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: .localized(.moviesSearchPrompt)
        )
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
    private func contentView() -> some View {
        List {
            Group {
                if store.isSearchActive {
                    resultsView()
                        .alignmentGuide(.listRowSeparatorLeading) { _ in
                            80 * Constants.ImageType.backdrop.ratio
                        }
                    
                } else {
                    suggestionsView()
                        .listRowSeparator(.hidden)
                }
            }
            .listRowBackground(Color.clear)
            .listSectionSeparator(.hidden, edges: [.top, .bottom])
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    private func suggestionsView() -> some View {
        let columns: [GridItem] = .init(
            repeating: GridItem(.flexible(), spacing: 12),
            count: 2
        )
        
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(store.genres) { genre in
                genreGridItem(genre)
            }
        }
    }
    
    @ViewBuilder
    private func genreGridItem(_ genre: Genre) -> some View {
        if let image = UIImage(named: genre.id.description) {
            Button {
                send(.onGenreTap(genre))
            } label: {
                ZStack(alignment: .bottomLeading) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(Constants.ImageType.backdrop.ratio, contentMode: .fill)
                        .cornerRadius(10)
                        .overlay {
                            LinearGradient(
                                colors: [.clear, .black.opacity(0.3)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(.ultraThinMaterial, lineWidth: 1)
                        }
                    
                    Text(genre.name ?? "")
                        .font(.rounded(.body))
                        .foregroundStyle(.white)
                        .padding(10)
                }
            }
            .buttonStyle(.plain)
        }
    }
    
    @ViewBuilder
    private func resultsView() -> some View {
        ForEach(store.results) { movie in
            Button {
                send(.onMovieTap(movie))
            } label: {
                MovieListItem(
                    movie: movie,
                    imageType: .backdrop
                )
                .frame(height: 70)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    NavigationStack {
        SearchView(
            store: Store(
                initialState: Search.State(),
                reducer: { Search() }
            )
        )
    }
}
