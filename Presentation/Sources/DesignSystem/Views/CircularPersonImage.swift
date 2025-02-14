//
//  CircularPersonImage.swift
//  Presentation
//
//  Created by Telem Tobi on 19/12/2023.
//

import SwiftUI
import Core
import Models

public struct CircularPersonImage: View {
    let person: Person
    let size: CGFloat
    
    public init(person: Person, size: CGFloat) {
        self.person = person
        self.size = size
    }
    
    public var body: some View {
        LazyImage(
            url: person.imageUrl,
            fallback: {
                ZStack {
                    Color.secondary.opacity(0.25)
                    Text(person.name?.initials ?? .empty)
                        .font(.rounded(.title, weight: .bold))
                }
            }
        )
        .centerCropped()
        .frame(width: size, height: size)
        .clipShape(Circle())
        .adaptiveConstrast(shape: .circle)
    }
}

#Preview {
    CircularPersonImage(
        person: CastMember.mock,
        size: 300
    )
}
