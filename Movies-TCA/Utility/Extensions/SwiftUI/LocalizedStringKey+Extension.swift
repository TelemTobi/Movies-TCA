//
//  LocalizedStringKey+Extension.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 07/01/2024.
//

import SwiftUI

extension LocalizedStringKey {
    
    static var empty: Self { LocalizedStringKey("") }
    static var notAvailable: Self { LocalizedStringKey("N/A") }
}
