//
//  MoviesListType.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 07/01/2024.
//

import Foundation
import SwiftUI

enum MoviesListType: String, CaseIterable {
    case nowPlaying, popular, upcoming, topRated
    
    var title: LocalizedStringKey {
        return switch self {
            case .nowPlaying: "Now Playing"
            case .popular: "Popular"
            case .upcoming: "Upcoming"
            case .topRated: "Top Rated"
        }
    }
}
