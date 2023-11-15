//
//  DiscoverView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 11/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct DiscoverView: View {
    
    let store: StoreOf<Discover>
    
    var body: some View {
        NavigationView {
            WithViewStore(store, observe: { $0 }) { viewStore in
                List {
                    ForEach(Discover.Section.allCases, id: \.self) { sectionType in
                        makeSection(for: sectionType)
                    }
                }
                .listStyle(.grouped)
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
                Image(systemName: "person.fill")
                    .foregroundColor(.accentColor)
            }
        }
    }
    
    @ViewBuilder
    private func makeSection(for section: Discover.Section) -> some View {
        Section {
            
        } header: {
            Text(section.title)
        }
        .headerProminence(.increased)
    }
}

#Preview {
    DiscoverView(
        store: .init(
            initialState: Discover.State(),
            reducer: { Discover() }
        )
    )
}
