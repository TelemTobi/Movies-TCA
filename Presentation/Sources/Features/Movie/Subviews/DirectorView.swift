//
//  DirectorView.swift
//  Presentation
//
//  Created by Telem Tobi on 20/12/2023.
//

import SwiftUI
import Models
import DesignSystem

struct DirectorView: View {
    
    let director: CrewMember
    let didTapDirector: (CrewMember) -> Void
    
    var body: some View {
        Button {
            didTapDirector(director)
        } label: {
            HStack(spacing: 0) {
                CircularPersonImage(person: director, size: 75)
                    .padding(.vertical, 8)
                
                VStack(alignment: .leading) {
                    Text("\(director.name ?? .notAvailable)")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("Director")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.forward")
                    .foregroundColor(.secondary)
                    .padding(.trailing, 5)
            }
            .transition(.slideAndFade)
        }
        .buttonStyle(.bordered)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    DirectorView(
        director: .mock,
        didTapDirector: { _ in }
    )
}
