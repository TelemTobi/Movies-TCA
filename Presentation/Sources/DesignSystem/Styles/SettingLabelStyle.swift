//
//  SettingLabelStyle.swift
//  Presentation
//
//  Created by Telem Tobi on 09/01/2024.
//

import SwiftUI

public struct SettingLabelStyle: LabelStyle {
    
    public let color: Color
    
    public init(color: Color) {
        self.color = color
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        Label(
            title: {
                configuration.title
                    .font(.rounded(.body, weight: .medium))
            },
            icon: {
                configuration.icon
                    .imageScale(.medium)
                    .frame(width: 24, height: 24)
                    .padding(2)
                    .foregroundStyle(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 7)
                            .foregroundStyle(color)
                    )
            }
        )
    }
}

public extension LabelStyle where Self == SettingLabelStyle {
    static func setting(color: Color) -> Self {
        SettingLabelStyle(color: color)
    }
}
