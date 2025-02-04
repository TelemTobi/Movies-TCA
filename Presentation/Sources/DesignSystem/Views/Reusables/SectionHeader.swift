//
//  SectionHeader.swift
//  Presentation
//
//  Created by Telem Tobi on 23/11/2023.
//

import SwiftUI
import Core

public struct SectionHeader: View {
    
    let title: LocalizedStringKey
    let action: EmptyClosure?
    
    public init(title: LocalizedStringKey, action: EmptyClosure? = nil) {
        self.title = title
        self.action = action
    }
    
    public var body: some View {
        HStack {
            if let action {
                Button {
                    action()
                } label: {
                    HStack(spacing: 4) {
                        Text(title)
                            .font(.rounded(.title2, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Image(systemName: "chevron.forward")
                            .font(.rounded(.body, weight: .bold))
                            .foregroundColor(.secondary)
                            .offset(y: 1)
                    }
                }
                .buttonStyle(.plain)
                
            } else {
                Text(title)
                    .font(.rounded(.title2, weight: .semibold))
                    .foregroundColor(.primary)

            }
            
            Spacer()
        }
    }
}


#Preview {
    SectionHeader(title: .localized(.nowPlaying)) {
        
    }
}
