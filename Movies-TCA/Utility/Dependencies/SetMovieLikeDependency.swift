//
//  SetMovieLikeDependency.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 25/03/2024.
//

import Foundation
import Dependencies

struct SetMovieLikeDependency : Sendable{
    var setMovieLike: @Sendable (Movie) -> Void
}

extension SetMovieLikeDependency: DependencyKey {
    
    static let liveValue = SetMovieLikeDependency(
        setMovieLike: { movie in
            @Dependency(\.database) var database
            
            if movie.isLiked {
                let likedMovie = LikedMovie(movie)
                try? database.context().insert(likedMovie)
            } else {
                let movieId = movie.id
                try? database.context().delete(
                    model: LikedMovie.self,
                    where: #Predicate { $0.id == movieId }
                )
            }
        }
    )
}

extension DependencyValues {
    var setMovieLike: @Sendable (Movie) -> Void {
        get { self[SetMovieLikeDependency.self].setMovieLike }
        set { self[SetMovieLikeDependency.self].setMovieLike = newValue }
    }
}
