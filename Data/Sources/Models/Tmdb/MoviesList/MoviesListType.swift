//
//  MovieListType.swift
//  Data
//
//  Created by Telem Tobi on 07/01/2024.
//

import Foundation
import SwiftUI
import Core

public enum MovieListType: String, CaseIterable, Sendable {
    case nowPlaying, watchlist, upcoming, popular, topRated
    
    public var title: LocalizedStringKey {
        return switch self {
        case .watchlist: .localized(.watchlist)
        case .nowPlaying: .localized(.nowPlaying)
        case .upcoming: .localized(.upcoming)
        case .popular: .localized(.popular)
        case .topRated: .localized(.topRated)
        }
    }
}
