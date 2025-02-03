//
//  EnvironmentValues+Extension.swift
//  Presentation
//
//  Created by Telem Tobi on 02/02/2025.
//

import SwiftUI

public extension EnvironmentValues {

    @Entry var namespace: Namespace.ID? = nil
    @Entry var transitionSource: TransitionSource? = nil
}

public enum TransitionSource: String {
    case pager
    case collection
}
