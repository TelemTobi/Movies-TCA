//
//  CircularPersonImage.swift
//  Presentation
//
//  Created by Telem Tobi on 19/12/2023.
//

import SwiftUI
import NukeUI
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
        LazyImage(url: person.imageUrl) { state in
            ZStack {
                if let image = state.image {
                    image.resizable()
                } else {
                    ZStack {
                        Color.secondary.opacity(0.25)
                        Text(person.name?.initials ?? .empty)
                            .foregroundColor(.white)
                            .font(.rounded(.title, weight: .bold))
                    }
                }
            }
            .animation(.smooth, value: state.image)
        }
        .centerCropped()
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}

#Preview {
    CircularPersonImage(
        person: CastMember.mock,
        size: 300
    )
}
