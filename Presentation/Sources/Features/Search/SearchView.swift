//
//  SearchView.swift
//  Presentation
//
//  Created by Telem Tobi on 24/11/2023.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

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
                        .listRowInsets(.zero)
                    
                } else {
                    suggestionsView()
                        .listRowSeparator(.hidden)
                }
            }
            .listRowBackground(Color.clear)
            .listSectionSeparator(.hidden, edges: .top)
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    private func suggestionsView() -> some View {
        let delays = Array(0..<store.genres.count).map { 0.2 + (CGFloat($0) * 0.05) }.shuffled()
        
        CapsulesView(items: store.genres) { index, genre in
            Button(
                action: {
                    send(.onGenreTap(genre))
                },
                label: {
                    Text(genre.name ?? .empty)
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
        .onFirstAppear {
            withAnimation { didFirstAppear = true }
        }
    }
    
    @MainActor
    @ViewBuilder
    private func resultsView() -> some View {
        ForEach(store.results) { movie in
            Button {
                send(.onMovieTap(movie))
            } label: {
                MovieListItem(
                    movie: movie,
                    imageType: .poster
                )
                .frame(height: 220)
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
