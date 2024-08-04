//
//  View+Extension.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 03/08/2024.
//

import SwiftUI

extension View {
    
    /// - Parameters:
    ///   - transform: A closure taking the original view and returning a modified content.
    /// - Returns: Returns the transformed content.
    @ViewBuilder
    func modify<Content: View>(transform: (Self) -> Content) -> some View {
        transform(self)
    }
    
    /// - Parameters:
    ///   - condition: A Boolean value determining whether the transformation should be applied.
    ///   - transform: A closure taking the original view and returning a modified content.
    /// - Returns: If the condition is true, returns the transformed content; otherwise, returns the original view.
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    /// - Parameters:
    ///   - value: An optional value that determines whether the transformation should be applied.
    ///   - transform: A closure taking the original view and the unwrapped value, returning a modified content.
    /// - Returns: If the optional value is non-nil, returns the transformed content; otherwise, returns the original view.
    @ViewBuilder
    func `ifLet`<T, Content: View>(_ value: T?, transform: (Self, T) -> Content) -> some View {
        if let value {
            transform(self, value)
        } else {
            self
        }
    }
}
