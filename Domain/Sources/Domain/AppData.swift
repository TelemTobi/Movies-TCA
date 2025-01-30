//
//  AppData.swift
//  Domain
//
//  Created by Telem Tobi on 29/01/2025.
//

import Foundation
import Dependencies
import Sharing
import Models
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

extension DependencyValues {
    var appData: AppData {
        get { self[AppData.self] }
    }
}
