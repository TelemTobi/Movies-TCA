//
//  StretchyHeader.swift
//  Presentation
//
//  Created by Telem Tobi on 15/12/2023.
//

import SwiftUI
import NukeUI
import Models
import Domain

public struct StretchyHeader<Header: View>: View {
    
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
    ///   - header: A closure that takes in no parameters and returns any View, used for building the header view.
    ///   - headerOffScreenOffset: A binding variable that projects the header off screen offset, 0 means header is fully visible and 1 meand that the header is fully scrolled out of screen.
    ///   - offScreenPercentageClosure: A closure that takes not parameters and returns a value between 0-1 indicating how much of the header is scrolled off screen,
    ///                                    0 means header is fully visible and 1 meand that the header is fully scrolled out of screen.
    public init(
        _ headerOffScreenOffset: Binding<CGFloat> = .constant(0),
        @ViewBuilder header: @MainActor @escaping () -> Header,
        headerOffScreenPercentageClosure: ((CGFloat) -> Void)? = nil
    ) {
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
                .clipShape(.bottomClip(height: geo.size.height))
                .didScroll { offset in
                    scrollOffset = offset
                    let offScreenPercentage = offset / geo.size.height
                    headerOffScreenPercentageClosure?(offScreenPercentage.clamped(to: 0...1))
                    self.offScreenOffset = offScreenPercentage.clamped(to: 0...1)
                }
        }
    }
}

#Preview {
    GeometryReader { geometry in
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                StretchyHeader {
                    let imageUrl = URL(string: "https://image.tmdb.org/t/p/original/uDgy6hyPd82kOHh6I95FLtLnj6p.jpg")
                    
                    LazyImage(url: imageUrl) { state in
                        if let image = state.image {
                            image.resizable()
                        } else {
                            TmdbImagePlaceholder()
                        }
                    }
                    .centerCropped()
                } headerOffScreenPercentageClosure: { offScreenPercentage in
                    // Do some animation with `offScreenPercentage`
                }
                .frame(height: geometry.size.width * 1.4)
                
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
        .ignoresSafeArea()
    }
}
