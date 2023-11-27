//
//  TabItemView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 26/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct TabItemView: View {
    
    let type: HomeFeature.Tab
    let store: StoreOf<TabItemFeature>
    
    var body: some View {
        NavigationStackStore(store.scope(state: \.path, action: { .path($0) })) {
            switch type {
            case .discover:
                DiscoverView(
                    store: store.scope(
                        state: \.discover,
                        action: { .discover($0) }
                    )
                )
                
            case .search:
                SearchView(
                    store: store.scope(
                        state: \.search,
                        action: { .search($0) }
                    )
                )
                
            case .watchlist:
                Text("Watchlist")
            }
            
        } destination: { state in
            switch state {
            case .moviesList:
                CaseLet(
                    /TabItemFeature.Path.State.moviesList,
                    action: TabItemFeature.Path.Action.moviesList,
                    then: MoviesListView.init(store:)
                )
            }
        }
    }
}

#Preview {
    TabItemView(
        type: .discover,
        store: Store(
            initialState: TabItemFeature.State(),
            reducer: { TabItemFeature() }
        )
    )
}
