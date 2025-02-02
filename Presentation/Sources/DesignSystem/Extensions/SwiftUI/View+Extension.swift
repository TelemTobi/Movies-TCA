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
}
