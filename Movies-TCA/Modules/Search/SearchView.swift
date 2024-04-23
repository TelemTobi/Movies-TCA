//
//  SearchView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 24/11/2023.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: SearchFeature.self)
struct SearchView: View {
    
    @Bindable var store: StoreOf<SearchFeature>
    @State private var didFirstAppear: Bool = false
    
    var body: some View {
        ZStack {
            if store.isLoading {
                ProgressView()
            } else {
                ContentView()
            }
        }
        .navigationTitle("Search")
        .toolbar(content: toolbarContent)
        .animation(.easeInOut, value: store.isLoading)
        .searchable(
            text: $store.searchInput.sending(\.onInputChange),
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Explore movies here"
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
    
    @MainActor
    @ViewBuilder
    private func ContentView() -> some View {
        List {
            Group {
                if store.isSearchActive {
                    ResultsView()
                        .listRowInsets(.zero)
                    
                } else {
                    SuggestionsView(genres: store.genres.elements)
                        .listRowSeparator(.hidden)
                }
            }
            .listRowBackground(Color.clear)
            .listSectionSeparator(.hidden, edges: .top)
        }
        .listStyle(.grouped)
        .scrollIndicators(.hidden)
    }
    
    @MainActor
    @ViewBuilder
    private func SuggestionsView(genres: [Genre]) -> some View {
        let delays = Array(0..<genres.count).map { 0.2 + (CGFloat($0) * 0.05) }.shuffled()
        
        TagCloudsView(tags: genres.compactMap(\.name)) { index, genre in
            Button(
                action: {
                    send(.onGenreTap(genres[index]))
                },
                label: {
                    Text(genre)
                        .font(.footnote)
                        .fontWeight(.medium)
                }
            )
            .buttonStyle(TagButtonStyle())
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
    private func ResultsView() -> some View {
        ForEach(store.results) { movie in
            Button {
                send(.onMovieTap(movie))
            } label: {
                MovieListItem(
                    movie: movie,
                    isLiked: .init(
                        get: { store.likedMovies.contains(movie) },
                        set: { _ in send(.onMovieLike(movie)) }
                    )
                )
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    NavigationStack {
        SearchView(
            store: Store(
                initialState: SearchFeature.State(),
                reducer: { SearchFeature() }
            )
        )
    }
}
