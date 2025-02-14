//
//  MediaContextMenu.swift
//  Presentation
//
//  Created by Telem Tobi on 14/02/2025.
//

import SwiftUI
import Core
import Models
import Sharing
import IdentifiedCollections

fileprivate struct MediaContextMenu: ViewModifier {
    
    let media: Movie
    let goToMedia: () -> Void
    let shareMedia: () -> Void
    let removeFromRecents: (() -> Void)?
    let toggleWatchlist: (() -> Void)?
    
    @Shared(.watchlist) private var watchlist: IdentifiedArrayOf<Movie> = []
    
    func body(content: Content) -> some View {
        content
            .contextMenu {
                contextMenu()
            } preview: {
                MovieGridItem(
                    movie: media,
                    imageType: .backdrop
                )
                .padding()
                .frame(width: 280)
            }
    }
    
    
    @ViewBuilder
    private func contextMenu() -> some View {
        if let removeFromRecents {
            Button(role: .destructive) {
                removeFromRecents()
            } label: {
                Label(.localized(.removeFromRecent), systemImage: "xmark.circle")
            }

            Divider()
        }
        
        Button {
            goToMedia()
        } label: {
            Label(.localized(.goToMovie), systemImage: "info.circle")
        }
        
        Button {
            shareMedia()
        } label: {
            Label(.localized(.share), systemImage: "square.and.arrow.up")
        }
        
        if let toggleWatchlist {
            Divider()
            
            let buttonRole: ButtonRole? = watchlist.contains(media) ? .destructive : nil
            let buttonTitle: Localization = watchlist.contains(media) ? .removeFromWatchlist : .addToWatchlist
            let buttonImage: String = watchlist.contains(media) ? "xmark.circle" : "plus.circle"
            
            Button(role: buttonRole) {
                toggleWatchlist()
            } label: {
                Label(.localized(buttonTitle), systemImage: buttonImage)
            }
        }
    }
}

public extension View {
    func mediaContextMenu(
        _ media: Movie,
        goToMedia: @escaping () -> Void,
        shareMedia: @escaping () -> Void,
        removeFromRecents: (() -> Void)? = nil,
        toggleWatchlist: (() -> Void)? = nil
    ) -> some View {
        modifier(
            MediaContextMenu(
                media: media,
                goToMedia: goToMedia,
                shareMedia: shareMedia,
                removeFromRecents: removeFromRecents,
                toggleWatchlist: toggleWatchlist
            )
        )
    }
}
