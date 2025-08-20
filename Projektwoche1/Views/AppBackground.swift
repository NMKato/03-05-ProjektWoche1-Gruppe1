//
//  AppBackground.swift
//  Projektwoche1
//
//  Created by Nikolas Kato on 20.08.25.
//

import SwiftUI

struct AppBackground: View {
    var body: some View {
        ZStack {
            // Fallback, falls Asset fehlt
            LinearGradient(colors: [.teal.opacity(0.25), .black.opacity(0.45)],
                           startPoint: .top, endPoint: .bottom)

            if UIImage(named: "mainBack_forest") != nil {
                Image("mainBack_forest")
                    .resizable()
                    .scaledToFill()
                    .overlay(LinearGradient(colors: [.black.opacity(0.10), .black.opacity(0.35)],
                                            startPoint: .top, endPoint: .bottom))
            }
        }
        .ignoresSafeArea(.container, edges: .all)
    }
}

#Preview {
    AppBackground()
}
