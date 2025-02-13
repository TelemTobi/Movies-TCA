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
    private func suggestionsView() -> some View {
        let delays = Array(0..<store.genres.count)
            .map { 0.2 + (CGFloat($0) * 0.05) }
            .shuffled()
        
        ScrollView {
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
            .padding(.horizontal)
            .onFirstAppear {
                withAnimation { didFirstAppear = true }
            }
        }
        .scrollIndicators(.hidden)
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
