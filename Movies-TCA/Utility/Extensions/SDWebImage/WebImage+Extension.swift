//
//  WebImage+Extension.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 15/12/2023.
//

import SDWebImageSwiftUI
import SwiftUI

extension WebImage {
    
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
