//
//  AppData+Extension.swift
//  Domain
//
//  Created by Telem Tobi on 30/01/2025.
//

import Dependencies
import Models

extension DependencyValues {
    var appData: AppData {
        get { self[AppData.self] }
    }
}
