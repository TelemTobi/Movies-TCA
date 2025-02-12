//
//  MovieListType+Extension.swift
//  Presentation
//
//  Created by Telem Tobi on 09/02/2025.
//

import Foundation
import Core
import Models

public extension MovieListType {
    
    var imageType: Constants.ImageType {
        switch self {
        case .nowPlaying: .poster
        case .watchlist: .backdrop
        case .upcoming: .poster
        case .popular: .backdrop
        case .topRated: .backdrop
        }
    }
    
    var indexed: Bool {
        switch self {
        case .topRated, .popular: true
        case .nowPlaying, .upcoming, .watchlist: false
        }
    }
}
