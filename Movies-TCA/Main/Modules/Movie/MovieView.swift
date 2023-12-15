//
//  MovieView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 24/11/2023.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

struct MovieView: View {
    
    let store: StoreOf<MovieFeature>
    
    @State private var headerOffScreenPercentage: CGFloat = 0
    @State private var headerTextColor: Color = .white
    @EnvironmentObject var statusBarConfigurator: StatusBarConfigurator
    
    private var navigationBarVisibilityThreshold: CGFloat = 0.85
    
    init(store: StoreOf<MovieFeature>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView(showsIndicators: false) {
                HeaderView(headerOffScreenPercentage: $headerOffScreenPercentage)
                    .environmentObject(viewStore)
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
        
        @EnvironmentObject private var viewStore: ViewStoreOf<MovieFeature>
        
        @Binding var headerOffScreenPercentage: CGFloat
        
        var body: some View {
            GeometryReader { geometry in
                ZStack(alignment: .bottom){
                    
                    StretchyHeader(
                        height: geometry.size.width * 1.4,
                        headerOffScreenOffset: $headerOffScreenPercentage,
                        header: {
                            WebImage(url: viewStore.movieDetails.movie?.posterUrl)
                                .resizable()
                                .scaledToFill()
                        }
                    )
                }
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
