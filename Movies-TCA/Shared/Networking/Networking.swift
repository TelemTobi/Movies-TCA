//
//  Networking.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 16/11/2023.
//

import Foundation
import Moya

protocol Networking {
    
    associatedtype EndPoint: TargetTypeEndPoint
    
    var provider: MoyaProvider<EndPoint> { get }
    var authenticator: Authenticating { get }
}

extension Networking {
    
    func request<T: Decodable, F: Errorable>(_ endpoint: EndPoint) async -> (T?, F?) {
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
