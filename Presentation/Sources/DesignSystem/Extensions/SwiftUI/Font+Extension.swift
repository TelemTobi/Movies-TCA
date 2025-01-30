//
//  Font+Extension.swift
//  Presentation
//
//  Created by Telem Tobi on 23/11/2023.
//

import SwiftUI

public extension Font {
    static func rounded(_ style: TextStyle, weight: Weight = .bold) -> Font {
        .system(style, design: .rounded, weight: weight)
    }
    
    var uiFont: UIFont {
        let uiFont: UIFont
        
        switch self {
        case .largeTitle:
            uiFont = UIFont.preferredFont(forTextStyle: .largeTitle)
        case .title:
            uiFont = UIFont.preferredFont(forTextStyle: .title1)
        case .headline:
            uiFont = UIFont.preferredFont(forTextStyle: .headline)
        case .subheadline:
            uiFont = UIFont.preferredFont(forTextStyle: .subheadline)
        case .body:
            uiFont = UIFont.preferredFont(forTextStyle: .body)
        case .callout:
            uiFont = UIFont.preferredFont(forTextStyle: .callout)
        case .footnote:
            uiFont = UIFont.preferredFont(forTextStyle: .footnote)
        case .caption:
            uiFont = UIFont.preferredFont(forTextStyle: .caption1)
        default:
            uiFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        }
        
        return uiFont.withSize(uiFont.pointSize)
    }
}
