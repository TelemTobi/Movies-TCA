//
//  SplashFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 04/03/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SplashFeature {
    
    @ObservableState
    struct State: Equatable {
        
    }
    
    enum Action: ViewAction {
        enum View {
        }
        
        case view(View)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            }
        }
    }
}
