//
//  Constants.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 22/11/2023.
//

import Foundation

typealias EmptyClosure = () -> Void
typealias MovieClosure = (Movie) -> Void

enum Constants {
    
    enum Environment {
        case live
        case test
    }
    
    enum Stub {
        static let delay: Int = 2
    }
    
    enum Layer {
        static var like: String { #function }
    }
}
