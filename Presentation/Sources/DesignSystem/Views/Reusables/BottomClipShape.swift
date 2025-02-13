//
//  BottomClipShape.swift
//  Presentation
//
//  Created by Telem Tobi on 07/02/2025.
//

import SwiftUI

struct BottomClipShape: Shape {
    
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

extension Shape where Self == BottomClipShape {
    static func bottomClip(height: CGFloat) -> Self {
        BottomClipShape(height: height)
    }
}
