//
//  Watchlist+Alerts.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 22/01/2024.
//

import Foundation
import SwiftUINavigationCore

extension AlertState where Action == WatchlistFeature.Action.Alert {
    
    static func dislikeConfirmation(for movie: Movie) -> Self {
        Self(
            title: {
                TextState("Are you sure?")
            },
            actions: {
                ButtonState(role: .destructive, action: .confirmDislike(movie)) {
                    TextState("Remove")
                }
                
                ButtonState(role: .cancel) {
                    TextState("Cancel")
                }
            },
            message: {
                TextState("Your'e about to remove \(movie.title ?? "") from your watchlist")
            }
        )
    }
}
