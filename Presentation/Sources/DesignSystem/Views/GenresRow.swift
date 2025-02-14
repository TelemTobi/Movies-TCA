//
//  GenresRow.swift
//  Presentation
//
//  Created by Telem Tobi on 12/02/2025.
//

import SwiftUI
import Core
import Models

public struct GenresRow: View {
    
    let genres: [Genre]
    let onGenreTap: (Genre) -> Void
    
    @Environment(\.namespace) private var namespace: Namespace.ID?
    
    public init(genres: [Genre], onGenreTap: @escaping (Genre) -> Void) {
        self.genres = genres
        self.onGenreTap = onGenreTap
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 8) {
                ForEach(genres, id: \.self) { genre in
                    itemView(genre)
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 16)
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }
    
    @ViewBuilder
    private func itemView(_ genre: Genre) -> some View {
        Button {
            onGenreTap(genre)
        } label: {
            ZStack {
                gradientBackground(for: genre)
                
                Text(genre.description)
                    .font(.rounded(.title3, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                    .padding()
            }
            .frame(width: 120, height: 120)
            .clipShape(.rect(cornerRadius: 10))
            .adaptiveConstrast(shadow: .off)
        }
        .buttonStyle(.plain)
        .scrollTransition(.interactive, axis: .horizontal) { view, phase in
            view.scaleEffect(phase.isIdentity ? 1 : 0.95)
        }
        .matchedTransitionSource(id: genre.description, in: namespace)
    }
    
    @ViewBuilder
    private func gradientBackground(for genre: Genre) -> some View {
        let colors: [Color] = switch genre {
        case .action: [.orange, .red.opacity(0.8), .orange, .red]
        case .scienceFiction: [.blue, .purple.opacity(0.8), .blue, .pink]
        case .comedy: [.green, .teal.opacity(0.8), .green, .yellow]
        case .thriller: [.indigo, .purple, .indigo, .purple.opacity(0.5)]
        case .drama: [.blue, .cyan.opacity(0.8), .blue, .cyan]
        default: [.blue, .purple.opacity(0.8), .blue, .pink]
        }
        
        MeshGradient(
            width: 2, height: 2,
            points: [[0, 0], [1, 0], [0, 1], [1, 1]],
            colors: colors
        )
        .background(Color.black)
    }
}

#Preview {
    GenresRow(
        genres: GenresResponse.mock.genres ?? [],
        onGenreTap: { _ in }
    )
    .frame(height: 150)
}
