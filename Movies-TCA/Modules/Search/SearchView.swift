//
//  SearchView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 24/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct SearchView: View {
    
    let store: StoreOf<SearchFeature>
    
    var body: some View {
        NavigationStack {
            WithViewStore(store, observe: { $0 }) { viewStore in
                ZStack {
                    if viewStore.isLoading {
                        ProgressView()
                    } else {
                        ContentView()
                            .environmentObject(viewStore)
                    }
                }
                .navigationTitle("Search")
                .toolbar(content: toolbarContent)
                .animation(.easeInOut, value: viewStore.isLoading)
                .searchable(
                    text: viewStore.$searchInput,
                    prompt: "Explore movies here"
                )
                .onFirstAppear {
                    viewStore.send(.onFirstAppear)
                }
            }
        }
    }
    
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                store.send(.onPreferencesTap)
            } label: {
                Image(systemName: "gear")
                    .foregroundColor(.accentColor)
            }
        }
    }
}

extension SearchView {
    
    private struct ContentView: View {
        
        @EnvironmentObject private var viewStore: ViewStoreOf<SearchFeature>
        
        var body: some View {
            List {
                Group {
                    if viewStore.isSearchActive {
                        ResultsView()
                            .listRowInsets(.zero)
                        
                    } else {
                        SuggestionsView(genres: viewStore.genres.elements)
                            .listRowSeparator(.hidden)
                    }
                }
                .listRowBackground(Color.clear)
                .listSectionSeparator(.hidden, edges: .top)
            }
            .listStyle(.grouped)
            .scrollIndicators(.hidden)
        }
    }
    
    private struct SuggestionsView: View {
        
        let genres: [Genre]
        @State private var didFirstAppear = false
        
        @EnvironmentObject private var viewStore: ViewStoreOf<SearchFeature>
        
        var body: some View {
            let delays = Array(0..<genres.count).map { 0.2 + (CGFloat($0) * 0.05) }.shuffled()
            
            TagCloudsView(tags: genres.compactMap(\.name)) { index, genre in
                Button(
                    action: {
                        viewStore.send(.onGenreTap(genres[index]))
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
    }
    
    private struct ResultsView: View {
        
        @EnvironmentObject private var viewStore: ViewStoreOf<SearchFeature>
        
        var body: some View {
            ForEach(viewStore.results) { movie in
                Button(
                    action: { viewStore.send(.onMovieTap(movie)) },
                    label: { MovieListItem(movie: movie) }
                )
                .padding()
                .frame(height: 200)
                .buttonStyle(.plain)
            }
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
