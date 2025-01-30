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
    let action: LocalizedStringKey?
    let onActionTap: EmptyClosure?
    
    public init(title: LocalizedStringKey, action: LocalizedStringKey? = nil, onActionTap: EmptyClosure? = nil) {
        self.title = title
        self.action = action
        self.onActionTap = onActionTap
    }
    
    public var body: some View {
        HStack {
            Text(title)
                .font(.rounded(.title2, weight: .semibold))
                .foregroundColor(.primary)
            
            Spacer()
            
            if let action, let onActionTap {
                Button {
                    onActionTap()
                } label: {
                    Text(action)
                        .font(.callout)
                        .foregroundColor(.accentColor)
                }
            }
        }
    }
}


#Preview {
    SectionHeader(title: "Now Playing", action: "See All") {
        
    }
}
