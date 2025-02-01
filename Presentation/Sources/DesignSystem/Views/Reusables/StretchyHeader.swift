//
//  StretchyHeader.swift
//  Presentation
//
//  Created by Telem Tobi on 15/12/2023.
//

import SwiftUI
import Kingfisher
import Models
import Domain

public struct StretchyHeader<Header: View>: View {
    
    private let height: CGFloat
    private let header: @MainActor () -> Header
    private let headerOffScreenPercentageClosure: (@MainActor (CGFloat) -> Void)?
    
    @State private var scrollOffset: CGFloat = 0
    @Binding private var offScreenOffset: CGFloat
    
    /// Sets up a header view that is scaled up when scrolled to negative offset values,
    /// and scales a bit down when scrolling to positive offset values.
    ///
    ///    **This view must be nested inside a ScrollView in order for it to work!**
    ///
    /// - Parameters:
    ///   - height: Used to determin the header view's height.
    ///   - header: A closure that takes in no parameters and returns any View, used for building the header view.
    ///   - headerOffScreenOffset: A binding variable that projects the header off screen offset, 0 means header is fully visible and 1 meand that the header is fully scrolled out of screen.
    ///   - offScreenPercentageClosure: A closure that takes not parameters and returns a value between 0-1 indicating how much of the header is scrolled off screen,
    ///                                    0 means header is fully visible and 1 meand that the header is fully scrolled out of screen.
    public init(
        height: CGFloat,
        headerOffScreenOffset: Binding<CGFloat> = .constant(0),
        @ViewBuilder header: @MainActor @escaping () -> Header,
        headerOffScreenPercentageClosure: ((CGFloat) -> Void)? = nil
    ) {
        self.height = height
        self.header = header
        self.headerOffScreenPercentageClosure = headerOffScreenPercentageClosure
        self._offScreenOffset = headerOffScreenOffset
    }
    
    public var body: some View {
        GeometryReader { geo in
            header()
                .scaleEffect(max(1 - (scrollOffset / geo.frame(in: .global).height), 1), anchor: .bottom)
                .position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
                .offset(y: max(scrollOffset / 1.25, 0))
                .clipShape(BottomClipShape(height: height))
                .didScroll { offset in
                    scrollOffset = offset
                    let offScreenPercentage = offset / geo.size.height
                    headerOffScreenPercentageClosure?(offScreenPercentage.clamped(to: 0...1))
                    self.offScreenOffset = offScreenPercentage.clamped(to: 0...1)
                }
        }
        .frame(height: height)
    }
}

fileprivate struct BottomClipShape: Shape {
    
    let height: CGFloat
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        let topOffset = height * 2
        
        path.move(to: CGPoint(x: 0, y: rect.minY - topOffset))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width, y: rect.minY - topOffset))
        path.closeSubpath()
        return path
    }
}

#Preview {
    GeometryReader { geometry in
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                StretchyHeader(height: geometry.size.width * 1.4) {
                    KFImage(URL(string: "https://image.tmdb.org/t/p/original/uDgy6hyPd82kOHh6I95FLtLnj6p.jpg"))
                        .centerCropped()
                } headerOffScreenPercentageClosure: { offScreenPercentage in
                    // Do some animation with `offScreenPercentage`
                }
                
                ForEach(0 ..< 5) { item in
                    Text(Movie.mock.title!)
                        .foregroundColor(.primary)
                        .font(.title).bold()
                        .padding(.top, 20)
                        .padding(.horizontal)
                    
                    Text(Movie.mock.overview!)
                        .foregroundColor(.primary)
                        .font(.callout)
                        .padding(.top, 10)
                        .padding(.horizontal)
                }
            }
        }
    }
}
