//
//  Font+Extension.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 23/11/2023.
//

import SwiftUI

extension Font {
    
    static func rounded(_ style: TextStyle, weight: Weight = .bold) -> Font {
        .system(style, design: .rounded, weight: weight)
    }
}
