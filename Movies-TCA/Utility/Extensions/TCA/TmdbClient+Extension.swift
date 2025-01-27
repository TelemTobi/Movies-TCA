//
//  TmdbClient+Extension.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 27/01/2025.
//

import Dependencies
import TmdbApi

extension TmdbClient: DependencyKey {
    public static let liveValue = TmdbClient(environment: .live)
    public static let testValue = TmdbClient(environment: .test)
    public static let previewValue = TmdbClient(environment: .preview)
}

public extension DependencyValues {
    
    var tmdbClient: TmdbClient {
        get { self[TmdbClient.self] }
        set { self[TmdbClient.self] = newValue }
    }
}
