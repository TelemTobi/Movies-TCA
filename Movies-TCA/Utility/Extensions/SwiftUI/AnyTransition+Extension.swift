//
//  AnyTransition+Extension.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 22/12/2023.
//

import SwiftUI

extension AnyTransition {
    
    static var slideAndFade: AnyTransition {
        .slide.combined(with: .opacity)
    }
}
