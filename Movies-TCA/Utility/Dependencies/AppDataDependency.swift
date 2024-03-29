//
//  AppDataDependency.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 04/03/2024.
//

import Foundation
import Dependencies

extension AppData: DependencyKey {
    
    static let liveValue = AppData()
    
    static let testValue = {
        let mockGenres = 
        AppData(genres: [])
    }()
}

extension DependencyValues {
    var appData: AppData {
        get { self[AppData.self] }
        set { self[AppData.self] = newValue }
    }
}
