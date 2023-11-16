//
//  TmdbClient.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 15/11/2023.
//

import Foundation
import ComposableArchitecture

struct TmdbClient {
    var fetchGenres: @Sendable () async -> (GenresResponse?, ApiError?)
    
    static private func makeRequest<T>(url: URL) async -> (T?, ApiError?) where T: Decodable {
        var request = URLRequest(url: url)
        request.setValue(Config.TmdbApi.accessToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299) ~= statusCode else {
                return (nil, .serverError)
            }
            
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                return (response, nil)
            } catch {
                return (nil, .decodingError)
            }
            
        } catch {
            return (nil, .badRequest)
        }
    }
}

extension TmdbClient {
    static let live = Self(
        fetchGenres: {
            await makeRequest(url: .init(string: "\(Config.TmdbApi.baseUrl)/genre/movie/list")!)
        }
    )
}
