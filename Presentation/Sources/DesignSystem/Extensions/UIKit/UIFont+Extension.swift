//
//  UIFont+Extension.swift
//  Presentation
//
//  Created by Telem Tobi on 14/02/2025.
//

import UIKit

public extension UIFont {
    static func rounded(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: size, weight: weight)

        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            return UIFont(descriptor: descriptor, size: size)
        }
        
        return systemFont
    }
}
