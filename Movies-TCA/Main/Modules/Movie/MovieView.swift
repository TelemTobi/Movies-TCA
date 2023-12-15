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
    
    @State private var headerOffScreenPercentage: CGFloat = 0
    @State private var headerTextColor: Color = .white
    @EnvironmentObject var statusBarConfigurator: StatusBarConfigurator
    
//    private var navigationBarVisibilityThreshold = 0.85
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView(showsIndicators: false) {
                /*@START_MENU_TOKEN@*/Text("Placeholder")/*@END_MENU_TOKEN@*/
            }
//            .navigationTitle(viewStore.movieDetails.movie?.title ?? .empty)
            .onFirstAppear {
                viewStore.send(.onFirstAppear)
            }
        }
    }
}

extension MovieView {
    
    private struct HeaderView: View {
        
        var body: some View {
            Text("Hello")
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
