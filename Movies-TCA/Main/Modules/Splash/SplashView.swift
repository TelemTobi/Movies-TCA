//
//  SplashView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 12/11/2023.
//

import SwiftUI

struct SplashView: View {
    
    var body: some View {
        VStack {
            Image(systemName: "sprinkler.and.droplets")
                .font(.largeTitle)
            Text("Splashing")
                .font(.title)
        }
    }
}

#Preview {
    SplashView()
}
