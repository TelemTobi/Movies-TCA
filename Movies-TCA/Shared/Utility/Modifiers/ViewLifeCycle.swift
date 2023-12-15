//
//  ViewLifeCycle.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 15/12/2023.
//

import SwiftUI

fileprivate struct WillDisappearHandler: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIViewController
    
    let onDidAppear: EmptyClosure?
    let onWillDisappear: EmptyClosure?
    
    init(onDidAppear: EmptyClosure? = nil, onWillDisappear: EmptyClosure? = nil) {
        self.onDidAppear = onDidAppear
        self.onWillDisappear = onWillDisappear
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<WillDisappearHandler>) -> UIViewController {
        context.coordinator
    }
    
    func makeCoordinator() -> WillDisappearHandler.Coordinator {
        Coordinator(onDidAppear: onDidAppear, onWillDisappear: onWillDisappear)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<WillDisappearHandler>) { }

    class Coordinator: UIViewController {
        
        let onDidAppear: EmptyClosure?
        let onWillDisappear: EmptyClosure?

        init(onDidAppear: EmptyClosure? = nil, onWillDisappear: EmptyClosure? = nil) {
            self.onDidAppear = onDidAppear
            self.onWillDisappear = onWillDisappear
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            onDidAppear?()
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            onWillDisappear?()
        }
    }
}

fileprivate struct WillAppear: ViewModifier {
    
    let completion: () -> Void

    func body(content: Content) -> some View {
        content.background(WillDisappearHandler(onDidAppear: completion))
    }
}

fileprivate struct WillDisappear: ViewModifier {
    
    let completion: () -> Void

    func body(content: Content) -> some View {
        content.background(WillDisappearHandler(onWillDisappear: completion))
    }
}

extension View {
    
    func onDidAppear(_ perform: @escaping () -> Void) -> some View {
        self.modifier(WillAppear(completion: perform))
    }
    
    func onWillDisappear(_ perform: @escaping () -> Void) -> some View {
        self.modifier(WillDisappear(completion: perform))
    }
}
