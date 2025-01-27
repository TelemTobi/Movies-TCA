//
//  CrewMember+Preview.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 25/12/2023.
//

import Foundation
import Models

extension CrewMember {
    
    static var mock: CrewMember {
        guard let crewMember = MovieDetails.mock.credits?.crew?.randomElement() else {
            fatalError("CrewMember mock decoding error")
        }
        return crewMember
    }
}
