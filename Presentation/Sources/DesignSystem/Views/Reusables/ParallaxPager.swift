//
//  ParallaxPager.swift
//  Presentation
//
//  Created by Telem Tobi on 22/11/2023.
//

import SwiftUI
import Core

public struct ParallaxPager<Content: View, Overlay: View, Collection: RandomAccessCollection>: View {
    
    let collection: Collection
    let spacing: CGFloat

    @Binding var currentItem: Collection.Element?
    
    @ViewBuilder let content: (Collection.Element) -> Content
    @ViewBuilder let overlay: (Collection.Element) -> Overlay
    
    @State private var scrollPosition: Int?
    @State private var items: [[Collection.Element]] = []
    
    /// Insert a description
    /// - Parameters:
    ///   - collection: The collection to iterate over
    ///   - spacing: The Amount of spacing between items
    ///   - content: Parallaxed content for item in the collection
    ///   - overlay: Overlay content for item in the collection
    public init(
        collection: Collection,
        spacing: CGFloat = 0,
        current: Binding<Collection.Element?> = .constant(nil),
        content: @escaping (Collection.Element) -> Content,
        overlay: @escaping (Collection.Element) -> Overlay
    ) {
        self.collection = collection
        self.spacing = spacing
        self._currentItem = current
        self.content = content
        self.overlay = overlay
    }
    
    public var body: some View {
        let items = items.flatMap { $0 }
        
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: spacing) {
                    ForEach(0..<items.count, id: \.self) { index in
                        let item = items[index]
                        
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
            .scrollPosition(id: $scrollPosition)
            .contentMargins(.horizontal, spacing, for: .scrollContent)
            .onFirstAppear {
                self.items = .init(repeating: collection.map { $0 }, count: 3)
                scrollPosition = collection.count
            }
            .onChange(of: scrollPosition) {
                guard let scrollPosition else { return }
                
                currentItem = self.items.flatMap { $0 }[scrollPosition]
                
                let itemCount = collection.count
                
                if scrollPosition / itemCount == 0, scrollPosition % itemCount == itemCount - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.items.removeLast()
                        self.items.insert(collection.map { $0 }, at: 0)
                        self.scrollPosition = scrollPosition + collection.count
                    }
                } else if scrollPosition / itemCount == 2, scrollPosition % itemCount == 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.items.removeFirst()
                        self.items.append(collection.map { $0 })
                        self.scrollPosition = scrollPosition - collection.count
                    }
                }
            }
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
