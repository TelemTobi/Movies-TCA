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
        Group {
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
                WatchlistView(
                    store: store.scope(
                        state: \.watchlist,
                        action: { .watchlist($0) }
                    )
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
