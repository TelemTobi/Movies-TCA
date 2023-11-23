//
//  SectionHeader.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 23/11/2023.
//

import SwiftUI

struct SectionHeader<Destination: View>: View {
    
    let title: String
    let action: String?
    let destination: Destination?
    
    init(title: String, action: String, @ViewBuilder destination: (() -> Destination)) {
        self.title = title
        self.action = action
        self.destination = destination()
    }
    
    init(title: String) where Destination == EmptyView {
        self.title = title
        self.action = nil
        self.destination = nil
    }
    
    var body: some View {
        
        HStack {
            
            Text(title)
                .font(.rounded(.title2, weight: .semibold))
                .foregroundColor(.primary)
            
            Spacer()
            
            if let destination, let action {
                NavigationLink {
                    destination
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
        Text("Hello, World!")
    }
}
