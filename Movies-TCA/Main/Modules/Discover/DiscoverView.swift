//
//  DiscoverView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 11/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct DiscoverView: View {
    
    let store: StoreOf<DiscoverFeature>
    
    var body: some View {
        NavigationStack {
            WithViewStore(store, observe: { $0 }) { viewStore in
                ZStack {
                    if viewStore.isLoading {
                        ProgressView()
                    } else {
                        ScrollView {
                            ForEach(MoviesList.ListType.allCases, id: \.self) { sectionType in
                                if let movies = viewStore.movies[sectionType] {
                                    makeSection(for: sectionType, movies: movies)
                                }
                            }
                            
                        }
                    }
                }
                .animation(.easeInOut, value: viewStore.isLoading)
                .onFirstAppear {
                    viewStore.send(.onFirstAppear)
                }
            }
            .toolbar(content: toolbarContent)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .foregroundColor(.accentColor)
            }
        }
    }
    
    @ViewBuilder
    private func makeSection(for section: MoviesList.ListType, movies: IdentifiedArrayOf<Movie>) -> some View {
        VStack {
            HStack {
                Text(section.title)
                    .font(.title3.weight(.medium))
                Spacer()
            }
            .padding(.horizontal)
            
            switch section {
            case .nowPlaying:
                MoviesPagerView(movies: movies)
            case .popular, .topRated, .upcoming:
                EmptyView()
            }
        }
        .padding(.bottom)
    }
}

#Preview {
    DiscoverView(
        store: .init(
            initialState: DiscoverFeature.State(),
            reducer: { DiscoverFeature() }
        )
    )
}
