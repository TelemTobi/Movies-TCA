//
//  MovieView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 24/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct MovieView: View {
    
    let store: StoreOf<MovieFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .navigationTitle(viewStore.movieDetails.movie?.title ?? .empty)
                .onFirstAppear {
                    viewStore.send(.onFirstAppear)
                }
        }
    }
}

#Preview {
    MovieView(
        store: Store(
            initialState: MovieFeature.State(movieDetails: .init(movie: .mock)),
            reducer: { MovieFeature() }
        )
    )
}
