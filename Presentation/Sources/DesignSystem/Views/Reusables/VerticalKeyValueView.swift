//
//  VerticalKeyValueView.swift
//  Presentation
//
//  Created by Telem Tobi on 22/12/2023.
//

import SwiftUI

public struct VerticalKeyValueView: View {
    
    public let key: String
    public let value: String
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(LocalizedStringKey(key))
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
