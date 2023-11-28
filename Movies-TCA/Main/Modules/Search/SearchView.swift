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
                        Text("Hello")
                    }
                    .listStyle(.grouped)
                    .scrollIndicators(.hidden)
                    .searchable(
                        text: viewStore.$searchInput,
                        prompt: "Search for cinematic treasures!"
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
