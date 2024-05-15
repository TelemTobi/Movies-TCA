//
//  TmdbClient+Dependency.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 21/11/2023.
//

import Foundation
import Dependencies

extension TmdbClient: DependencyKey {
    static let liveValue = TmdbClient(environment: .live)
    static let testValue = TmdbClient(environment: .test)
    static let previewValue = TmdbClient(environment: .preview)
}

extension DependencyValues {
    
    var tmdbClient: TmdbClient {
        get { self[TmdbClient.self] }
        set { self[TmdbClient.self] = newValue }
    }
}
