//
//  DynamicHeight.swift
//  Presentation
//
//  Created by Telem Tobi on 16/12/2023.
//

import SwiftUI

fileprivate struct DynamicHeight: ViewModifier {
    
    @State private var height: CGFloat = .zero
    
    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { geometry in
                    Color.clear.preference(
                        key: InnerHeightPreferenceKey.self,
                        value: geometry.size.height
                    )
                }
            }
            .onPreferenceChange(InnerHeightPreferenceKey.self) { newHeight in
                DispatchQueue.main.async {
                    height = newHeight
                }
            }
            .presentationDetents([.height(height)])
    }
}

public extension View {
    func dynamicHeight() -> some View {
        modifier(DynamicHeight())
    }
}

fileprivate struct InnerHeightPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGFloat = .zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
