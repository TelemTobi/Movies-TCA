//
//  CapsulesView.swift
//  Presentation
//
//  Created by Telem Tobi on 28/11/2023.
//

import SwiftUI

public struct CapsulesView<Content, T>: View where Content : View, T : Hashable {
    
    public var items: Array<T>
    public var contentForItem: (Int, T) -> Content

    @State private var totalHeight: CGFloat
          = .zero       // << variant for ScrollView/List
    //    = .infinity   // << variant for VStack
    
    public var body: some View {
        VStack {
            GeometryReader { geometry in
                generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)// << variant for ScrollView/List
        //.frame(maxHeight: totalHeight) // << variant for VStack
    }

    @MainActor
    @ViewBuilder
    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        ZStack(alignment: .topLeading) {
            ForEach(Array(items.enumerated()), id: \.element) { index, item in
                contentForItem(index, item)
                    .padding(.vertical, 6)
                    .padding(.trailing, 8)
                    .alignmentGuide(.leading) { dimension in
                        if abs(width - dimension.width) > geometry.size.width {
                            width = 0
                            height -= dimension.height
                        }
                        
                        let result = width
                        
                        if item == self.items.last {
                            width = 0
                        } else {
                            width -= dimension.width
                        }
                        
                        return result
                    }
                    .alignmentGuide(.top) { dimension in
                        let result = height
                        
                        if item == items.last {
                            height = 0
                        }
                        
                        return result
                    }
            }
        }
        .background(viewHeightReader($totalHeight))
    }

    @MainActor
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}
