//
//  CastMembersView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 19/12/2023.
//

import SwiftUI

extension MovieView {
    
    struct CastMembersView: View {
        
        @State var castMembers: [CastMember]
        
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20) {
                    
                    ForEach(castMembers.prefix(10)) { member in
                        NavigationLink {
                            Text(member.name ?? .notAvailable)
                        } label: {
                            ItemView(member: member)
                        }
                        .buttonStyle(.plain)
                        .transition(.slide.combined(with: .opacity))
                    }
                }
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
}

#Preview {
    MovieView.CastMembersView(castMembers: MovieDetails.mock.credits?.cast ?? [])
}