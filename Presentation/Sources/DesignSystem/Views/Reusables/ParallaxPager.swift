//
//  ParallaxPager.swift
//  Presentation
//
//  Created by Telem Tobi on 22/11/2023.
//

import SwiftUI

public struct ParallaxPager<Content: View, Overlay: View, Collection: RandomAccessCollection>: View {
    
    let collection: Collection
    let spacing: CGFloat

    @ViewBuilder let content: (Collection.Element) -> Content
    @ViewBuilder let overlay: (Collection.Element) -> Overlay
    
    public init(
        collection: Collection,
        spacing: CGFloat = 0,
        content: @escaping (Collection.Element) -> Content,
        overlay: @escaping (Collection.Element) -> Overlay
    ) {
        self.collection = collection
        self.spacing = spacing
        self.content = content
        self.overlay = overlay
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: spacing) {
                    ForEach(0..<collection.count, id: \.self) { index in
                        let item = collection[_offset: index]
                        
                        itemWrapper(
                            content: { content(item) },
                            overlay: { overlay(item) }
                        )
                        .frame(width: geometry.size.width)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .contentMargins(.horizontal, spacing, for: .scrollContent)
        }
    }
    
    @ViewBuilder
    private func itemWrapper(content: @escaping () -> Content, overlay:  @escaping () -> Overlay) -> some View {
        GeometryReader { geometry in
            let itemSize = geometry.size
            let minX = geometry.frame(in: .scrollView).minX * 0.5
            
            content()
                .aspectRatio(contentMode: .fill)
                .scaleEffect(1.05)
                .offset(x: -minX)
                .frame(width: itemSize.width, height: itemSize.height)
                .overlay { overlay() }
                .clipShape(.rect)
        }
        
    }
}

public final class InfiniteArray<Content>: RandomAccessCollection {
    private var elements: [Content]
    
    public init(elements: [Content]) {
        self.elements = elements
    }
    
    public var startIndex: Int { Int(Int32.min) }
    public var endIndex: Int { Int(Int32.max) }
    
    public subscript(position: Int) -> Content {
        let index = (elements.count + (position % elements.count)) % elements.count
        return elements[index]
    }
}
