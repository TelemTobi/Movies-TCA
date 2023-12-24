//
//  PreferencesView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 29/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct PreferencesView: View {

    let store: StoreOf<PreferencesFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .navigationTitle("Preferences")
        }
    }
}

#Preview {
    PreferencesView(
        store: Store(
            initialState: PreferencesFeature.State(),
            reducer: { PreferencesFeature() }
        )
    )
}
