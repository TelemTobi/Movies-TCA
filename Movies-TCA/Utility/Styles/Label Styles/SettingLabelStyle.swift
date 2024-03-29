//
//  SettingLabelStyle.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 09/01/2024.
//

import SwiftUI

struct SettingLabelStyle: LabelStyle {
    
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        Label(
            title: { configuration.title },
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
