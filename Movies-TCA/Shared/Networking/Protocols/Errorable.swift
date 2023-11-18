//
//  Errorable.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 16/11/2023.
//

import Foundation

protocol Errorable: Error {
    
    var debugDescription: String { get }
    init(_ errorType: PredefinedError)
}
