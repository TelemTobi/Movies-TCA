//
//  SplashView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 12/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct SplashView: View {
    
    let store: StoreOf<Splash>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    SplashView(
        store: .init(
            initialState: Splash.State(),
            reducer: { Splash() }
        )
    )
}
