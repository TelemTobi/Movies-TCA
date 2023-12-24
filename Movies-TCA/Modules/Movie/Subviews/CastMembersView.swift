//
//  CastMembersView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 19/12/2023.
//

import SwiftUI

struct CastMembersView: View {
    
    @State var castMembers: [CastMember]
    let didTapCastMember: (CastMember) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                
                ForEach(castMembers.prefix(10)) { member in
                    Button {
                        didTapCastMember(member)
                    } label: {
                        ItemView(member: member)
                    }
                    .buttonStyle(.plain)
                    .transition(.slideAndFade)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private struct ItemView: View {
        
        var member: CastMember
        private let size: CGFloat = 110
        
        var body: some View {
            VStack {
                CircularPersonImage(person: member, size: size)
                
                Text(member.name ?? .empty)
                    .foregroundColor(.primary)
                    .font(.subheadline)
                    .frame(maxWidth: size)
                    .lineLimit(1)
                
                Text(member.character ?? .empty)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                    .frame(maxWidth: size)
                    .lineLimit(2)
            }
            .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    CastMembersView(
        castMembers: MovieDetails.mock.credits?.cast ?? [],
        didTapCastMember: { _ in }
    )
}
