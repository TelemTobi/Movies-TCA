//
//  LikedMovie.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 19/01/2024.
//

import Foundation
import SwiftData

@Model
class LikedMovie {
    
    @Attribute(.unique)
    let id: Int?
    
    let title: String?
    let overview: String?
    let posterPath: String?
    
    init(_ movie: Movie) {
        self.id = movie.id
        self.title = movie.title
        self.overview = movie.overview
        self.posterPath = movie.posterPath
    }
    
    var toMovie: Movie {
        Movie(
            id: self.id,
            overview: self.overview,
            posterPath: self.posterPath,
            title: self.title,
            isLiked: true
        )
    }
}
