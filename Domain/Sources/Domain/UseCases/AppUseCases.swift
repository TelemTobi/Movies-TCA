//
//  AppUseCases.swift
//  Domain
//
//  Created by Telem Tobi on 29/01/2025.
//

import Foundation
import Dependencies
import UIKit

public struct AppUseCases: Sendable {
    public let openURL: @Sendable (URL) -> Void
    public let openAppSettings: @Sendable () -> Void
}

extension AppUseCases: DependencyKey {
    public static let liveValue = AppUseCases(
        openURL: { url in
            Task { @MainActor in
                await UIApplication.shared.open(url)
            }
        },
        openAppSettings: {
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            
            Task { @MainActor in
                await UIApplication.shared.open(url)
            }
        }
    )
}

extension DependencyValues {
    var appUseCases: AppUseCases {
        get { self[AppUseCases.self]}
    }
}
