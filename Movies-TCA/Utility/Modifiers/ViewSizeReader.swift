//
//  ViewSizeReader.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 24/01/2024.
//

import SwiftUI

struct ViewSizeReader: ViewModifier {
    
    let onChange: (CGSize) -> Void
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: SizePreferenceKey.self, value: geometry.size)
                }
            )
            .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        modifier(ViewSizeReader(onChange: onChange))
    }
}

fileprivate struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
