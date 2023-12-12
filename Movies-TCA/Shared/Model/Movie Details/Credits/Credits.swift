//
//  Credits.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 12/12/2023.
//

import Foundation

struct Credits: Decodable, Equatable {
    
    let cast: [Actor]?
    let crew: [CrewMember]?
}
