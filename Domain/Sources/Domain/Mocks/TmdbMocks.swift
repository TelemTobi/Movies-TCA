//
//  TmdbTmdbMocks.swift
//  Data
//
//  Created by Telem Tobi on 30/01/2025.
//

import Foundation
import Models
import TmdbApi

public extension GenresResponse {
    static var mock: GenresResponse {
        let response = try? TmdbMock.listGenres
            .decode(into: GenresResponse.self)
        
        guard let response else {
            fatalError("Movies mock decoding error")
        }
        
        return response
    }
}

public extension Genre {
    static var mock: Genre {
        let genre = GenresResponse.mock.genres?.randomElement()
        
        guard let genre else {
            fatalError("Movies mock decoding error")
        }
        
        return genre
    }
}

public extension Movie {
    static var mock: Movie {
        let movie = try? TmdbMock.nowPlayingMovies
            .decode(into: MovieList.self, using: .tmdbDateDecodingStrategy)
            .movies?.randomElement()
        
        guard let movie else {
            fatalError("Movies mock decoding error")
        }
        
        return movie
    }
}

public extension MovieList {
    static var mock: MovieList {
        let movieList = try? TmdbMock.nowPlayingMovies
            .decode(into: MovieList.self, using: .tmdbDateDecodingStrategy)
        
        guard let movieList else {
            fatalError("Movies mock decoding error")
        }
        
        return movieList
    }
}

public extension DetailedMovie {
    static var mock: DetailedMovie {
        let movie = try? DetailedMovie.self
            .map(TmdbMock.movieDetails.dataEncoded)
            .decode(into: DetailedMovie.self, using: .tmdbDateDecodingStrategy)
        
        guard let movie else {
            fatalError("MovieDetails mock decoding error")
        }
        
        return movie
    }
}

public extension CastMember {
    static var mock: CastMember {
        guard let castMember = DetailedMovie.mock.credits?.cast?.randomElement() else {
            fatalError("CastMember mock decoding error")
        }
        return castMember
    }
}

public extension CrewMember {
    static var mock: CrewMember {
        guard let crewMember = DetailedMovie.mock.credits?.crew?.randomElement() else {
            fatalError("CrewMember mock decoding error")
        }
        return crewMember
    }
}
