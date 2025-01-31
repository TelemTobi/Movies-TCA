//
//  AnyTransition+Extension.swift
//  Presentation
//
//  Created by Telem Tobi on 22/12/2023.
//

import SwiftUI

public extension AnyTransition {
    static var slideAndFade: AnyTransition {
        .slide.combined(with: .opacity)
    }
}
