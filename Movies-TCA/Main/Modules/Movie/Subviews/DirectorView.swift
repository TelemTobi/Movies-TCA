//
//  DirectorView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 20/12/2023.
//

import SwiftUI

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
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .padding(.trailing, 5)
            }
            .transition(.slide.combined(with: .opacity))
        }
        .buttonStyle(.bordered)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    DirectorView(
        director: .mock,
        didTapDirector: { _ in }
    )
    .previewLayout(.sizeThatFits)
}
