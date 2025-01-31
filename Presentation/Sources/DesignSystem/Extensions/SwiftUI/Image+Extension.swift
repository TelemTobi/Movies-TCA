//
//  Image+Extension.swift
//  Presentation
//
//  Created by Telem Tobi on 31/01/2025.
//

import SwiftUI

public extension Image {
    
    enum Resource: String {
        case splashLogo
        case tmdbLogo
    }
    
    init(_ resource: Resource) {
        self.init(resource.rawValue, bundle: .module)
    }
}
