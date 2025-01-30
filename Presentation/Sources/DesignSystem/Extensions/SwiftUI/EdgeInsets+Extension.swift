//
//  EdgeInsets+Extension.swift
//  Presentation
//
//  Created by Telem Tobi on 23/11/2023.
//

import SwiftUI

public extension EdgeInsets {    
    static var zero: EdgeInsets {
        .init(top: 0, leading: 0, bottom: 0, trailing: 0)
    }
    
    init(_ value: CGFloat) {
        self.init(top: value, leading: value, bottom: value, trailing: value)
    }
}

