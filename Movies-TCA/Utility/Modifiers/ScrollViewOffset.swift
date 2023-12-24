//
//  ScrollViewOffset.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 15/12/2023.
//

import SwiftUI

fileprivate struct ViewOffsetKey: PreferenceKey {
    
    typealias Value = CGFloat
    
    static var defaultValue = CGFloat.zero
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

fileprivate struct CalculateScrollOffset: ViewModifier {
    
    @Binding var offset: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background {
                GeometryReader {
                    Color.clear.preference(
                        key: ViewOffsetKey.self,
                        value: -$0.frame(in: .named("scroll")).origin.y
                    )
                }
            }
            .onPreferenceChange(ViewOffsetKey.self) {
                offset = $0
            }
    }
}

fileprivate struct DoWhenScrolled: ViewModifier {
    
    var didScroll: ((CGFloat) -> Void)?
    
    func body(content: Content) -> some View {
        content
            .background {
                GeometryReader {
                    Color.clear
                        .preference(
                            key: ViewOffsetKey.self,
                            value: -$0.frame(in: .named("scroll")).origin.y
                        )
                }
            }
            .onPreferenceChange(ViewOffsetKey.self) {
                didScroll?($0)
            }
    }
}

extension View {
    
    /// Add this modifier on any view that is nested inside a scroll view to receive a scroll offset to the passed completion block
    func didScroll(_ completion: @escaping (CGFloat) -> Void) -> some View {
        modifier(DoWhenScrolled(didScroll: completion))
    }
    
    /// Add this modifier on any view that is nested inside a scroll view to receive a scroll offset to the passed offset binding object
    func calculateScrollOffset(_ offset: Binding<CGFloat>) -> some View {
        modifier(CalculateScrollOffset(offset: offset))
    }
}
