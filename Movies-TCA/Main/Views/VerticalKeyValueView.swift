//
//  VerticalKeyValueView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 22/12/2023.
//

import SwiftUI

struct VerticalKeyValueView: View {
    
    let key: String
    let value: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            Text(key)
                .foregroundColor(.secondary)
                .font(.footnote)
            
            Text(value)
                .foregroundColor(.primary)
                .font(.headline)
        }
        .transition(.slideAndFade)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    VerticalKeyValueView(key: "Key", value: "Value")
}
