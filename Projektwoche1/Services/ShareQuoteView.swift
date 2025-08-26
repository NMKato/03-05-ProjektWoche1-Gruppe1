//
//  ShareQuoteView.swift
//  Projektwoche1
//
//  Created by 4Gi .tv on 24.08.25.
//

import SwiftUI

struct ShareQuoteView: View {
    let text: String
    let author: String
    let category: Category?

    /// Hintergrund für Share (ggf. auf "ShareTemplate_9x16" ändern)
    var backgroundAsset: String = "MUSE_Share_Design"

    /// Zielgröße des Render-Bildes (wird vom Renderer/Call-Site gesetzt)
    var canvasSize: CGSize = CGSize(width: 1024, height: 1024)

    /// Anteil der Kartenbreite an der Canvas-Breite (0.0 ... 1.0)
    ///
    var contentWidthRatio: CGFloat = 0.86

    /// Skalierungsfaktor relativ zu einem 1080px-Design
    private var k: CGFloat { canvasSize.width / 1080.0 }

    var body: some View {
        ZStack {
            Image(backgroundAsset)
                .resizable()
                .scaledToFill()
                .frame(width: canvasSize.width, height: canvasSize.height)
                .clipped()
                .ignoresSafeArea()

            LinearGradient(colors: [.black.opacity(0.06), .black.opacity(0.35)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 14 * k) {
                HStack(spacing: 12 * k) {
                    Image(category?.icon ?? "muse_neutral")
                        .resizable().scaledToFit()
                        .frame(width: max(140, 180 * k), height: max(140, 180 * k))
                        .shadow(color: .black.opacity(0.3), radius: 6 * k, y: 3 * k)

                    VStack(alignment: .leading, spacing: 8) {
                        Text(category?.displayName ?? "Zitat")
                            .font(.system(size: 42, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                            .textCase(.uppercase)
                            .tracking(2)
                        
                        Text("von MUSE")
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.8))
                            .textCase(.lowercase)
                    }

                    Spacer()
                }

                VStack(alignment: .leading, spacing: 24) {
                    quoteTextView
                    authorTextView
                }
                .padding(48)
                .background(cardBackground)
            }
            .frame(width: canvasSize.width * contentWidthRatio)
            .padding(40 * k)
        }
        .frame(width: canvasSize.width, height: canvasSize.height)
        .preferredColorScheme(.dark) // optional, für konstante Darstellung
    }

    // MARK: - Computed Views
    
    private var quoteTextView: some View {
        Text("\"\(text)\"")
            .font(.system(size: 72, weight: .bold, design: .rounded))
            .foregroundStyle(.white)
            .lineSpacing(10)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
            .shadow(color: .black.opacity(0.4), radius: 6, y: 3)
    }
    
    private var authorTextView: some View {
        HStack {
            Spacer()
            Text("— \(author)")
                .font(.system(size: 44, weight: .semibold, design: .serif))
                .foregroundStyle(.white)
                .italic()
                .shadow(color: .black.opacity(0.3), radius: 3, y: 2)
        }
    }
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 32 * k, style: .continuous)
            .fill(categoryGradient(category))
            .overlay(cardBorder)
            .shadow(color: .black.opacity(0.35), radius: 28 * k, y: 14 * k)
    }
    
    private var cardBorder: some View {
        RoundedRectangle(cornerRadius: 32 * k, style: .continuous)
            .strokeBorder(.white.opacity(0.15), lineWidth: 2 * k)
    }
    
    private func categoryGradient(_ c: Category?) -> LinearGradient {
        switch c {
        case .motivation:   return .init(colors: [.orange.opacity(0.75), .red.opacity(0.65)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .wisdom:       return .init(colors: [.indigo.opacity(0.75), .blue.opacity(0.65)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .programming:  return .init(colors: [.mint.opacity(0.75), .teal.opacity(0.65)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .drinking:     return .init(colors: [.pink.opacity(0.75), .purple.opacity(0.65)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .mindset:      return .init(colors: [.cyan.opacity(0.75), .indigo.opacity(0.65)], startPoint: .topLeading, endPoint: .bottomTrailing)
        default:            return .init(colors: [.gray.opacity(0.45), .gray.opacity(0.25)], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}
