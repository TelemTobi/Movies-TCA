//
//  TruncableText.swift
//  Presentation
//
//  Created by Telem Tobi on 24/01/2024.
//

import SwiftUI

public struct TruncableText: View {
    
    let text: String
    let lineLimit: Int
    let truncationUpdate: (Bool) -> Void
    
    @State private var intrinsicSize: CGSize = .zero
    @State private var truncatedSize: CGSize = .zero
    
    public init(_ text: String, lineLimit: Int, truncationUpdate: @escaping (Bool) -> Void) {
        self.text = text
        self.lineLimit = lineLimit
        self.truncationUpdate = truncationUpdate
    }
    
    public var body: some View {
        Text(text)
            .lineLimit(lineLimit)
            .readSize { size in
                truncatedSize = size
                truncationUpdate(truncatedSize != intrinsicSize)
            }
            .background(
                Text(text)
                    .fixedSize(horizontal: false, vertical: true)
                    .hidden()
                    .readSize { size in
                        intrinsicSize = size
                        truncationUpdate(truncatedSize != intrinsicSize)
                    }
            )
    }
}

#Preview {
    let text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    
    return TruncableText(text, lineLimit: 3, truncationUpdate: { _ in })
        .lineLimit(3)
        .padding()
}
