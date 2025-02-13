//
//  View+Extension.swift
//  Presentation
//
//  Created by Telem Tobi on 02/02/2025.
//

import SwiftUI

public extension View {
    
    @ViewBuilder
    func modify<Content: View>(@ViewBuilder _ transform: (Self) -> Content?) -> some View {
        if let view = transform(self) {
            view
        } else {
            self
        }
    }
    
    func backgroundColor(_ resource: Color.Resource) -> some View {
        self.background(Color(resource))
    }
    
    @ViewBuilder
    func zoomTransition(sourceID: some Hashable, in namespace: Namespace.ID?) -> some View {
        if let namespace {
            self.navigationTransition(.zoom(sourceID: sourceID, in: namespace))
        } else {
            self
        }
    }
    
    @ViewBuilder
    func matchedTransitionSource(id: some Hashable, in namespace: Namespace.ID?) -> some View {
        if let namespace {
            self.matchedTransitionSource(id: id, in: namespace)
        } else {
            self
        }
    }
}
