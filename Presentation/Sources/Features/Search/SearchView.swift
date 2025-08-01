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
    @State var didFirstAppear: Bool = false
    
    public init(store: StoreOf<Search>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            switch store.viewState {
            case .suggestions:
                suggestionsView()
                
            case .loading:
                ProgressView()
                
            case let .searchResult(movies):
                resultsView(movies)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .backgroundColor(.background)
        .animation(.snappy, value: store.viewState)
        .navigationTitle(.localized(.search))
        .navigationBarTitleDisplayMode(.inline)
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
    private func resultsView(_ movies: IdentifiedArrayOf<Movie>) -> some View {
        List {
            ForEach(movies) { movie in
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
            .scrollIndicators(.hidden)
            .listRowBackground(Color.clear)
            .listSectionSeparator(.hidden, edges: [.top, .bottom])
            .alignmentGuide(.listRowSeparatorLeading) { _ in
                80 * Constants.ImageType.backdrop.ratio
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
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
