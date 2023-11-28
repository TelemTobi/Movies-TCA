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
                    List {
                        GenresTagsView(genres: viewStore.genres.elements)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listSectionSeparator(.hidden, edges: .top)
                    }
                    .listStyle(.grouped)
                    .scrollIndicators(.hidden)
                    .searchable(
                        text: viewStore.$searchInput,
                        prompt: "Find movie marvels! What's your genre?"
                    )
                }
            }
            .navigationTitle("Search")
            .animation(.easeInOut, value: viewStore.isLoading)
            .onFirstAppear {
                viewStore.send(.onFirstAppear)
            }
        }
    }
}

private struct GenresTagsView: View {
    
    let genres: [Genre]
    @State private var didFirstAppear = false
    
    var body: some View {
        let delays = Array(0..<genres.count).map { CGFloat($0) * 0.05 }.shuffled()
        
        TagCloudsView(tags: genres.compactMap(\.name)) { index, genre in
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                Text(genre)
                    .font(.footnote)
                    .fontWeight(.medium)
            }
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
