//
//  HomepageSection.swift
//  Presentation
//
//  Created by Telem Tobi on 12/02/2025.
//

import Foundation
import Core

public enum HomepageSection: Equatable {
    case nowPlaying
    case watchlist
    case upcoming
    case popular
    case genres
    case topRated
    
    public var title: String? {
        switch self {
        case .nowPlaying: nil
        case .watchlist: .localized(.watchlist)
        case .upcoming: .localized(.upcoming)
        case .popular: .localized(.popular)
        case .genres: .localized(.discoverByGenre)
        case .topRated: .localized(.topRated)
        }
    }
    
    public var imageType: Constants.ImageType {
        switch self {
        case .nowPlaying: .poster
        case .watchlist: .backdrop
        case .upcoming: .poster
        case .popular: .backdrop
        case .topRated: .backdrop
        default: .poster
        }
    }
    
    public var indexed: Bool {
        switch self {
        case .topRated, .popular: true
        case .nowPlaying, .upcoming, .watchlist: false
        default: false
        }
    }
    
    public var itemWidth: CGFloat {
        switch self {
        case .watchlist: 240
        case .popular, .topRated: 160
        case .upcoming, .nowPlaying: 160
        case .genres: 180
        }
    }
    
    public var isExpandable: Bool {
        switch self {
        case .genres: false
        default: true
        }
    }
}
