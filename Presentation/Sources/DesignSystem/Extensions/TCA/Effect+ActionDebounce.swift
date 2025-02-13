//
//  Effect+ActionDebounce.swift
//  Presentation
//
//  Created by Telem Tobi on 10/02/2025.
//

import Foundation
import ComposableArchitecture

public extension Effect {
    enum ActionDebounce {
        case loading
        case textInput
        
        var duration: TimeInterval {
            switch self {
            case .loading: 0.5
            case .textInput: 1.0
            }
        }
        
        var scheduler: AnySchedulerOf<DispatchQueue> {
            // In case background/other queue is needed - use a switch statement here
            @Dependency(\.mainQueue) var mainQueue
            return mainQueue
        }
    }
    
    
    /// Turns an effect into one that can be debounced according to the `ActionDebounce` behavior parameter.
    ///
    /// The scheduler delivers the debounced output to, is set by the `type` parameter.
    /// - Parameters:
    ///   - type: The `ActionDebounce` behavior.
    /// - Returns: An effect that publishes events only after the `type.duration` elapses.
    func debounce(for type: ActionDebounce) -> Self {
        debounce(id: "\(Action.self)-\(type)", for: .seconds(type.duration), scheduler: type.scheduler)
    }
}
