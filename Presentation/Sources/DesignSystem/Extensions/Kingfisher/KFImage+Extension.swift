//
//  KFImage+Extension.swift
//  Presentation
//
//  Created by Telem Tobi on 31/01/2025.
//

import SwiftUI
import Kingfisher

public extension KFImage {
    func centerCropped() -> some View {
        GeometryReader { geo in
            self
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
        }
    }
}
