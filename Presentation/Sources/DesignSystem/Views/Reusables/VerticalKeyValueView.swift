//
//  VerticalKeyValueView.swift
//  Presentation
//
//  Created by Telem Tobi on 22/12/2023.
//

import SwiftUI

public struct VerticalKeyValueView: View {
    
    let key: String
    let value: String
    
    public init(key: String, value: String) {
        self.key = key
        self.value = value
    }
    
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
