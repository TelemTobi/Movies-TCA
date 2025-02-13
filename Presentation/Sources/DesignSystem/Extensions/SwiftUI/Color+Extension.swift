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
        case placeholder
    }
    
    init(_ resource: Resource) {
        self.init(resource.rawValue, bundle: .module)
    }
    
    init(resource: Resource) {
        self.init(resource.rawValue, bundle: .module)
    }
}
