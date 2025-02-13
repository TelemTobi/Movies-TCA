//
//  TmdbMock.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 22/11/2023.
//

import Foundation
import Networking

#if DEBUG
public enum TmdbMock: String {
    
    case listGenres = "ListGenresStub"
    case nowPlayingMovies = "NowPlayingMoviesStub"
    case popularMovies = "PopularMoviesStub"
    case topRatedMovies = "TopRatedMoviesStub"
    case upcomingMovies = "UpcomingMoviesStub"
    case searchMovies = "SearchMoviesStub"
    case discoverMovies = "DiscoverMoviesStub"
    case movieDetails = "MovieDetailsStub"
    
    var fileName: String {
        switch self {
        default:
            return self.rawValue
        }
    }
    
    var stringFromFile: String {
        guard let filePath = Bundle.module.path(forResource: fileName, ofType: "json") else {
            fatalError("Stub Json file named: \(fileName) was not found.")
        }
        
        do {
            return try String(contentsOfFile: filePath)
        } catch (let error) {
            fatalError(error.localizedDescription)
        }
    }
    
    public var dataEncoded: Data {
        stringFromFile.data(using: .utf8)!
    }
    
    public func decode<T: Decodable>(into type: T.Type, using dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, _ keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) throws -> T {
        try self.dataEncoded.decode(into: type, using: dateDecodingStrategy, keyDecodingStrategy)
    }
}
#endif
