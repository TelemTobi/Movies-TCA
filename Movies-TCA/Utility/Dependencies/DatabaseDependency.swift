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
    var getContext: @Sendable () throws -> ModelContext
    var getLikedMovies: @Sendable () throws -> [LikedMovie]
    var setMovieLike: @Sendable (Movie) throws -> Void
}

extension DatabaseDependency: DependencyKey {
    static let liveValue = DatabaseDependency(
        getContext: { appContext },
        getLikedMovies: {
            try appContext.fetch(FetchDescriptor<LikedMovie>())
        },
        setMovieLike: { movie in
            if movie.isLiked {
                let likedMovie = LikedMovie(movie)
                appContext.insert(likedMovie)
            } else {
                let movieId = movie.id
                try appContext.delete(
                    model: LikedMovie.self,
                    where: #Predicate { $0.id == movieId }
                )
            }
        }
    )
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
