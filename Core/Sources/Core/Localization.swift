//
//  Localization.swift
//  Core
//
//  Created by Telem Tobi on 01/02/2025.
//

import Foundation
import Localization
import SwiftUI

@Localizable
public enum Localization {
    case addToWatchlist
    case adultContent
    case appearance
    case areYouSure
    case budget
    case cancel
    case cast
    case categories
    case close
    case country
    case dark
    case directedBy
    case director
    case done
    case genres
    case discoverByGenre
    case goToMovie
    case information
    case language
    case light
    case more
    case movies
    case moviesSearchPrompt
    case notAvailable
    case nowPlaying
    case numberOfVotes(String)
    case originalTitle
    case popular
    case preferences
    case recentlyViewed
    case related
    case releaseDate
    case remove
    case removeFromRecent
    case removeFromWatchlist
    case revenue
    case runtime
    case search
    case seeAll
    case share
    case status
    case system
    case topRated
    case tvShows
    case upcoming
    case watchlist
    case watchlistEmptyStateContent
    case watchlistEmptyStateTitle
    case watchlistRemovalAlertContent(movieTitle: String)
}

public extension String {
    static func localized(_ key: Localization) -> Self {
        key.localized
    }
}
public extension LocalizedStringKey {
    static func localized(_ key: Localization) -> Self {
        LocalizedStringKey(key.localized)
    }
}
