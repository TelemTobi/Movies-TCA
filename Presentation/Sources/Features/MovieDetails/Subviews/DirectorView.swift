//
//  DirectorView.swift
//  Presentation
//
//  Created by Telem Tobi on 20/12/2023.
//

import SwiftUI
import Core
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
                    Text("\(director.name ?? .localized(.notAvailable))")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(.localized(.director))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.forward")
                    .font(.rounded(.body, weight: .bold))
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
