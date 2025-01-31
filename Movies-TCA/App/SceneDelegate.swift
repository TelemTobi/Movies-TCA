//
//  SceneDelegate.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 31/01/2025.
//

import Foundation
import Combine
import UIKit
import Core
import Sharing
import Models

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var subscriptions: Set<AnyCancellable> = []
    
    @Shared(.appearance) private var appearance = .system
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        self.window = windowScene.keyWindow
        subscribeToColorSchemeChanges()
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
