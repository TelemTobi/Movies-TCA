//
//  MoviesListView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 26/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct MoviesListView: View {
    
    let store: StoreOf<MoviesListFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    MoviesListView(
        store: Store(
            initialState: MoviesListFeature.State(),
            reducer: { MoviesListFeature() }
        )
    )
}
