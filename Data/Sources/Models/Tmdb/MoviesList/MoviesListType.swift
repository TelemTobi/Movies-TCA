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
    case nowPlaying, popular, upcoming, topRated
    
    public var title: LocalizedStringKey {
        return switch self {
        case .nowPlaying: .localized(.nowPlaying)
        case .popular: .localized(.popular)
        case .upcoming: .localized(.upcoming)
        case .topRated: .localized(.topRated)
        }
    }
}
