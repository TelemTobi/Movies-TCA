//
//  UIWindow+Extension.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 15/12/2023.
//

import UIKit

extension UIWindow {
    
    static var main: UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
              let window = windowSceneDelegate.window else {
            return nil
        }
        return window
    }
}
