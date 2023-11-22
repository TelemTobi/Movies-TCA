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
        NavigationView {
            WithViewStore(store, observe: { $0 }) { viewStore in
                if viewStore.isLoading {
                    ProgressView()
                        .onFirstAppear {
                            viewStore.send(.onFirstAppear)
                        }
                } else {
                    ScrollView {
                        ForEach(MoviesList.ListType.allCases, id: \.self) { sectionType in
                            makeSection(for: sectionType)
                        }
                    }
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
                Image(systemName: "person.fill")
                    .foregroundColor(.accentColor)
            }
        }
    }
    
    @ViewBuilder
    private func makeSection(for section: MoviesList.ListType) -> some View {
        Section {
            ScrollView(.horizontal) {
                LazyHStack {
                    switch section {
                        case .nowPlaying:
                            EmptyView()
                        case .popular, .topRated, .upcoming:
                            EmptyView()
                    }
                }
            }
        } header: {
            HStack {
                Text(section.title)
                    .font(.title3.weight(.medium))
                Spacer()
            }
        }
        .padding(.horizontal)
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
