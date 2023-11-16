//
//  TmdbClient.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 15/11/2023.
//

import Foundation
import ComposableArchitecture

struct TmdbClient {
    var fetchGenres: @Sendable () async throws -> [Genre]
}

extension TmdbClient {
    static let live = Self(
        fetchGenres: {
            var request = URLRequest(url: .init(string: "\(Config.TmdbApi.baseUrl)/genre/movie/list")!)
            request.setValue(Config.TmdbApi.accessToken, forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "content-type")
            
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                let response = try JSONDecoder().decode(GenresResponse.self, from: data)
                return response.genres ?? []
            } catch(let error) {
                // TODO: Find a way to handle errors properly
                fatalError(error.localizedDescription)
            }
        }
    )
}
