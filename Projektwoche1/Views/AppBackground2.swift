//
//  AppBackground2.swift
//  Projektwoche1
//
//  Created by Nikolas Kato on 21.08.25.
//

import SwiftUI

struct AppBackground2: View {
    var body: some View {
        ZStack {
            // Fallback, falls Asset fehlt
            LinearGradient(colors: [.teal.opacity(0.25), .black.opacity(0.45)],
                           startPoint: .top, endPoint: .bottom)

            if UIImage(named: "favBack01") != nil {
                Image("favBack01")
                    .resizable()
                    .scaledToFill()
                    .overlay(LinearGradient(colors: [.black.opacity(0.10), .black.opacity(0.35)],
                                            startPoint: .top, endPoint: .bottom))
            }
        }
        .ignoresSafeArea(.container, edges: [.top, .bottom])
    }
}

#Preview {
    AppBackground2()
}
