//
//  SearchView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 24/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct SearchView: View {
    
    @Bindable var store: StoreOf<SearchFeature>
    
    @State private var didFirstAppear: Bool = false
    
    var body: some View {
        NavigationStack {
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
            .onFirstAppear {
                store.send(.onFirstAppear)
            }
        }
    }
    
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(
                action: { store.send(.onPreferencesTap) },
                label: {
                    Image(systemName: "gear")
                        .foregroundColor(.accentColor)
                }
            )
        }
    }
    
    @ViewBuilder @MainActor
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
    
    @ViewBuilder @MainActor
    private func SuggestionsView(genres: [Genre]) -> some View {
        let delays = Array(0..<genres.count).map { 0.2 + (CGFloat($0) * 0.05) }.shuffled()
        
        TagCloudsView(tags: genres.compactMap(\.name)) { index, genre in
            Button(
                action: {
                    store.send(.onGenreTap(genres[index]))
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
    
    @ViewBuilder @MainActor
    private func ResultsView() -> some View {
        ForEach(store.results) { movie in
            MovieListButton(
                movie: movie,
                onMovieTap: { store.send(.onMovieTap($0)) },
                onLikeTap: { store.send(.onMovieLike($0)) }
            )
            .padding()
            .frame(height: 200)
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
