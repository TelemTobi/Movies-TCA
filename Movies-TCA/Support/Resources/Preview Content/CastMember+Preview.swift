//
//  CastMember+Preview.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 25/12/2023.
//

import Foundation
import Models

extension CastMember {
    
    static var mock: CastMember {
        guard let castMember = MovieDetails.mock.credits?.cast?.randomElement() else {
            fatalError("CastMember mock decoding error")
        }
        return castMember
    }
}
