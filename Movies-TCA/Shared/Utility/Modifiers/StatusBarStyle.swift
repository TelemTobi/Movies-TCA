//
//  StatusBarStyle.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 15/12/2023.
//


import SwiftUI

@MainActor
class StatusBarConfigurator: ObservableObject {
    
    private var window: UIWindow?
    
    var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            UIView.animate(withDuration: 0.15) { [weak self] in
                guard let self = self else { return }
                window?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    fileprivate func prepare(scene: UIWindowScene) {
        if window == nil {
            let window = UIWindow(windowScene: scene)
            let viewController = ViewController()
            viewController.configurator = self
            window.rootViewController = viewController
            window.frame = UIScreen.main.bounds
            window.alpha = 0
            self.window = window
        }
        window?.windowLevel = .statusBar
        window?.makeKeyAndVisible()
    }
    
    fileprivate class ViewController: UIViewController {
        weak var configurator: StatusBarConfigurator!
        override var preferredStatusBarStyle: UIStatusBarStyle { configurator.statusBarStyle }
    }
}

fileprivate struct SceneFinder: UIViewRepresentable {
    
    var getScene: ((UIWindowScene) -> ())?
    
    func makeUIView(context: Context) -> View {
        View()
    }
    
    func updateUIView(_ uiView: View, context: Context) {
        uiView.getScene = getScene
    }
    
    class View: UIView {
        
        var getScene: ((UIWindowScene) -> ())?
        
        override func didMoveToWindow() {
            if let scene = window?.windowScene, !ProcessInfo.isPreviewEnvironment {
                getScene?(scene)
            }
        }
    }
}

fileprivate struct StatusBarStyle: ViewModifier {
    
    @EnvironmentObject private var statusBarConfigurator: StatusBarConfigurator
    
    let style: UIStatusBarStyle
    
    func body(content: Content) -> some View {
        content
            .prepareStatusBarConfigurator(statusBarConfigurator)
            .onAppear { statusBarConfigurator.statusBarStyle = style }
            .onDidAppear { statusBarConfigurator.statusBarStyle = style }
    }
}

extension View {
    
    @MainActor
    func prepareStatusBarConfigurator(_ configurator: StatusBarConfigurator) -> some View {
        background(SceneFinder { scene in configurator.prepare(scene: scene) })
    }
    
    func statusBarStyle(_ style: UIStatusBarStyle) -> some View {
        modifier(StatusBarStyle(style: style))
    }
}
