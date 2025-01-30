//
//  CircularPersonImage.swift
//  Presentation
//
//  Created by Telem Tobi on 19/12/2023.
//

import SwiftUI
import SDWebImageSwiftUI
import Core
import Models

public struct CircularPersonImage: View {
    public let person: Person
    public let size: CGFloat
    
    public var body: some View {
        WebImage(url: person.imageUrl)
            .placeholder {
                ZStack {
                    Circle()
                        .overlay {
                            Color.gray
                        }
                    
                    Text(person.name?.initials ?? .empty)
                        .foregroundColor(.white)
                        .font(.rounded(.title, weight: .bold))
                }
            }
            .resizable()
            .centerCropped()
            .frame(width: size, height: size)
            .clipShape(Circle())
            .transition(.fade)
    }
}

//#Preview {
//    CircularPersonImage(
//        person: CastMember.mock,
//        size: 300
//    )
//}
