//
//  TagCloudsView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 28/11/2023.
//

import SwiftUI

struct TagCloudsView<Content: View>: View {
    
    var tags: [String]
    var item: (Int, String) -> Content

    @State private var totalHeight: CGFloat
          = .zero       // << variant for ScrollView/List
    //    = .infinity   // << variant for VStack

    init(tags: [String], @ViewBuilder item: @escaping (Int, String) -> Content) {
        self.tags = tags
        self.item = item
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)// << variant for ScrollView/List
        //.frame(maxHeight: totalHeight) // << variant for VStack
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(Array(tags.enumerated()), id: \.element) { index, tag in
                self.item(index, tag)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if tag == self.tags.last {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if tag == self.tags.last {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }.background(viewHeightReader($totalHeight))
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}
