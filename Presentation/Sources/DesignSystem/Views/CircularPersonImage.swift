//
//  CircularPersonImage.swift
//  Presentation
//
//  Created by Telem Tobi on 19/12/2023.
//

import SwiftUI
import Kingfisher
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
        KFImage(person.imageUrl)
            .placeholder {
                ZStack {
                    Color.gray
                    Text(person.name?.initials ?? .empty)
                        .foregroundColor(.white)
                        .font(.rounded(.title, weight: .bold))
                }
            }
            .fade(duration: 0.5)
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
