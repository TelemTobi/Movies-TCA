//
//  DynamicSheet.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 18/12/2023.
//

import SwiftUI

struct DynamicSheet<Content: View>: View {
    
    let title: String
    let content: () -> Content
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                DoneButtonLabel
                    .opacity(0)
                
                Spacer()
                
                Text(title)
                    .fontWeight(.medium)
                    .frame(alignment: .center)
                
                Spacer()
                
                Button() {
                    dismiss()
                } label: {
                    DoneButtonLabel
                }
            }
            
            content()
                .padding(.top)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .dynamicHeight()
    }
    
    private var DoneButtonLabel: some View {
        Text("Done")
            .fontWeight(.semibold)
            .foregroundColor(.accentColor)
    }
}
