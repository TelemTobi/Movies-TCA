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
            .searchable(
                text: viewStore.$searchInput,
                prompt: "Find movie marvels! What's your genre?"
            )
            .animation(.easeInOut, value: viewStore.isLoading)
            .onFirstAppear {
                viewStore.send(.onFirstAppear)
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
                        ResultsView(movies: viewStore.results)
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
        
        let movies: IdentifiedArrayOf<Movie>
        
        @EnvironmentObject private var viewStore: ViewStoreOf<SearchFeature>
        
        var body: some View {
            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
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
