import SwiftUI

fileprivate struct OnFirstAppearModifier: ViewModifier {
    
    let action: () -> Void
    @State private var isFirstTime: Bool = true
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if isFirstTime {
                    isFirstTime = false
                    action()
                }
            }
    }
}

extension View {
    
    func onFirstAppear(perform action: @escaping () -> Void) -> some View {
        modifier(OnFirstAppearModifier(action: action))
    }
}
