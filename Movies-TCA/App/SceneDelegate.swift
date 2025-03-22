//
//  SceneDelegate.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 31/01/2025.
//

import Foundation
import Combine
import UIKit
import SwiftUI
import Sharing
import Core
import Models
import DesignSystem

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var subscriptions: Set<AnyCancellable> = []
    
    @Shared(.appearance) private var appearance = .system
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        self.window = windowScene.keyWindow
        applyAppearanceModifications()
        subscribeToColorSchemeChanges()
    }

    private func applyAppearanceModifications() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        
        appearance.largeTitleTextAttributes = [
            .font: UIFont.rounded(size: 42, weight: .bold)
        ]
        
        appearance.titleTextAttributes = [
            .font : UIFont.rounded(size: 18, weight: .medium)
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    private func subscribeToColorSchemeChanges() {
        self.window?.overrideUserInterfaceStyle = appearance.userInterfaceStyle
        
        $appearance.publisher
            .sink { newValue in
                guard let window = self.window else { return }
                
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
                    window.overrideUserInterfaceStyle = newValue.userInterfaceStyle
                }
            }
            .store(in: &subscriptions)
    }
}

fileprivate extension Constants.Appearance {
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .system: .unspecified
        case .light: .light
        case .dark: .dark
        }
    }
}
