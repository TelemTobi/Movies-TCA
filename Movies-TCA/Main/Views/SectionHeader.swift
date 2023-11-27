//
//  SectionHeader.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 23/11/2023.
//

import SwiftUI

struct SectionHeader: View {
    
    let title: String
    let action: String?
    let onActionTap: EmptyClosure?
    
    init(title: String, action: String? = nil, onActionTap: EmptyClosure? = nil) {
        self.title = title
        self.action = action
        self.onActionTap = onActionTap
    }
    
    var body: some View {
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
