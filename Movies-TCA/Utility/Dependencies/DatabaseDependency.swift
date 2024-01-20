//
//  DatabaseDependency.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 20/01/2024.
//

import Foundation
import SwiftData
import Dependencies

struct DatabaseDependency {
    var context: @Sendable () throws -> ModelContext
}

extension DatabaseDependency: DependencyKey {
    static let liveValue = Self(context: { appContext })
}

extension DependencyValues {
    var database: DatabaseDependency {
        get { self[DatabaseDependency.self] }
        set { self[DatabaseDependency.self] = newValue }
    }
}

fileprivate let appContext: ModelContext = {
    do {
        let url = URL.applicationSupportDirectory.appending(path: "Database.sqlite")
        let schema = Schema([LikedMovie.self])
        let config = ModelConfiguration(schema: schema, url: url)
        
        let container = try ModelContainer(for: schema, configurations: config)
        return ModelContext(container)
        
    } catch {
        fatalError("Failed to create container")
    }
}()
