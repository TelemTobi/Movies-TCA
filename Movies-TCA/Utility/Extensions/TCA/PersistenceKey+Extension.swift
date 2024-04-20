//
//  PersistenceKey+Extension.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 20/04/2024.
//

import Foundation
import ComposableArchitecture

extension PersistenceKey where Self == AppStorageKey<Constants.Appearance> {
    static var appearance: Self { .appStorage("appearance") }
}

extension PersistenceKey where Self == AppStorageKey<Bool> {
    static var adultContent: Self { .appStorage("isAdultContentOn") }
}
