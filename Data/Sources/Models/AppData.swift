//
//  AppData.swift
//  Domain
//
//  Created by Telem Tobi on 29/01/2025.
//

import Foundation
import Dependencies
import Sharing
import IdentifiedCollections

public actor AppData {
    public var genres: [Genre] = []
    
    @Shared(.watchlist) public var watchlist: IdentifiedArrayOf<Movie> = []
    
    public func setGenres(_ genres: [Genre]) {
        self.genres = genres
    }
}

extension AppData: DependencyKey {
    public static var liveValue = AppData()
    public static var testValue = AppData()
}
