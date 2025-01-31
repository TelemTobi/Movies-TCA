//
//  Credits.swift
//  Data
//
//  Created by Telem Tobi on 12/12/2023.
//

import Foundation

public struct Credits: Decodable, Equatable, Sendable {
    
    public let cast: [CastMember]?
    public let crew: [CrewMember]?
    
    public var director: CrewMember? {
        crew?.first(where: { $0.job == "Director" })
    }
}
