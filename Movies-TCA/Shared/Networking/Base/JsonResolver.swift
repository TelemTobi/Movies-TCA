//
//  JsonResolver.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 17/11/2023.
//

import Foundation

protocol JsonResolver {
    static func resolve(_ data: Data) throws -> Data
}

extension JsonResolver {
    static func resolve(_ data: Data) throws -> Data { data }
}
