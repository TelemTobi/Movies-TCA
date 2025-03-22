//
//  GenreDetailsView.swift
//  Presentation
//
//  Created by Telem Tobi on 13/02/2025.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import MovieCollectionFeature

@ViewAction(for: GenreDetails.self)
public struct GenreDetailsView: View {
    
    public let store: StoreOf<GenreDetails>
    
    @Environment(\.namespace) private var namespace: Namespace.ID?
    
    public init(store: StoreOf<GenreDetails>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            switch store.viewState {
            case .loading:
                ProgressView() // TODO: Consider replacing with shimmering
                
            case .loaded:
                if let store = store.scope(state: \.movieCollection, action: \.movieCollection) {
                    MovieCollectionView(store: store)
                }
                
            case .error:
                EmptyView() // TODO: Handle error
            }
        }
        .animation(.smooth, value: store.viewState)
        .navigationTitle(store.genre.description)
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .backgroundColor(.background)
        .onAppear { send(.onAppear) }
        .zoomTransition(sourceID: store.genre.description, in: namespace)
    }
}

#Preview {
    GenreDetailsView(
        store: Store(
            initialState: GenreDetails.State(genre: .action),
            reducer: GenreDetails.init
        )
    )
}
