//
//  Color+Extension.swift
//  Presentation
//
//  Created by Telem Tobi on 04/02/2025.
//

import SwiftUI

public extension Color {

    enum Resource: String {
        case background
        case foreground
    }
    
    init(_ resource: Resource) {
        self.init(resource.rawValue, bundle: .module)
    }
}
