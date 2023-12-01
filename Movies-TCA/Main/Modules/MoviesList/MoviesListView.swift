//
//  MoviesListView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 26/11/2023.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

struct MoviesListView: View {
    
    let store: StoreOf<MoviesListFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List {
                ForEach(viewStore.movies) { movie in
                    Button(
                        action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/,
                        label: { ItemView(movie: movie) }
                    )
                    .padding()
                    .frame(height: 180)
                    .buttonStyle(.plain)
                }
                .listRowInsets(.zero)
                .listRowBackground(Color.clear)
                .listSectionSeparator(.hidden, edges: .top)
            }
            .listStyle(.grouped)
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(viewStore.listType.title)
            .onFirstAppear {
                viewStore.send(.onFirstAppear)
            }
        }
    }
}

extension MoviesListView {
    
    private struct ItemView: View {
        
        let movie: Movie
        
        var body: some View {
            GeometryReader { geometry in
                let imageWidth = geometry.size.height / 1.6
                let imageHeight = geometry.size.height

                HStack(spacing: 10) {
                    WebImage(url: movie.thumbnailUrl)
                        .resizable()
                        .placeholder {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.gray)
                                .frame(width: imageWidth, height: imageHeight)
                            
                            Image(systemName: "popcorn")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40)
                                .foregroundColor(.white)
                        }
                        .scaledToFill()
                        .frame(width: imageWidth, height: imageHeight)
                        .cornerRadius(5)
                        .transition(.fade)
                        .shadow(radius: 3)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(movie.title ?? "")
                            .lineLimit(2)
                            .font(.title2.weight(.bold))
                            .layoutPriority(1)
                        
                        Text(movie.overview ?? "")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        
                        Spacer(minLength: 2)
                        
                        HStack(spacing: 5) {
                            Spacer()
                            
                            Image(systemName: "heart.circle.fill")
                                .foregroundStyle(.pink)
                            Text(movie.voteAverageFormatted)
                        }
                        .font(.footnote)
                        .padding(.horizontal, 5)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MoviesListView(
            store: Store(
                initialState: MoviesListFeature.State(
                    listType: .nowPlaying,
                    movies: [.mock, .mock]
                ),
                reducer: { MoviesListFeature() }
            )
        )
    }
}
