//
//  PreferencesInteractor.swift
//  Presentation
//
//  Created by Telem Tobi on 29/01/2025.
//

import Foundation
import Dependencies
import Models
import Domain

struct PreferencesInteractor: Sendable {
    @Dependency(\.useCases.app) private var app
    
    func openAppSettings() {
        app.openAppSettings()
    }
}

extension PreferencesInteractor: DependencyKey {
    static let liveValue = PreferencesInteractor()
    static let testValue = PreferencesInteractor()
}
