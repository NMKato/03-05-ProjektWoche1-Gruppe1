//
//  MascotView.swift
//  Projektwoche1
//
//  Created by Nikolas Kato on 20.08.25.
//

import SwiftUI

struct MascotView: View {
    let mood: Mood?
    let domain: LifeDomain?
    var size: CGFloat = 64

    // Aura-Farbe (subtil)
    private var accent: Color {
        switch mood {
        case .freude:      return Color(hex: 0xF59E0B)
        case .traurig:     return Color(hex: 0x2563EB)
        case .unsicher:    return Color(hex: 0x14B8A6)
        case .enttaeuscht: return Color(hex: 0x8B5CF6)
        case .none:        return Color(hex: 0x6B7280)
        }
    }

    // Bildname des Fuchs-Gesichts
    private var faceAsset: String {
        switch mood {
        case .freude:      return "muse_happy"
        case .traurig:     return "muse_sad"
        case .unsicher:    return "muse_unsure"
        case .enttaeuscht: return "muse_disappointed"
        case .none:        return "muse_neutral"
        }
    }

    // Badge
    private var badgeAsset: String? {
        guard let d = domain else { return nil }
        switch d {
        case .work:        return "badge_work"
        case .leisure:     return "badge_leisure"
        case .privateLife: return "badge_private"
        }
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(accent.opacity(0.10))
                .frame(width: size, height: size)

            // Maskottchen (Asset) – Fallback auf SFSymbol, falls Asset fehlt
            if UIImage(named: faceAsset) != nil {
                Image(faceAsset)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size * 0.78, height: size * 0.78)
            } else {
                Image(systemName: "paperplane.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size * 0.58, height: size * 0.58)
                    .foregroundStyle(.primary)
            }

            // Domain-Badge
            if let badge = badgeAsset, UIImage(named: badge) != nil {
                Image(badge)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size * 0.28, height: size * 0.28)
                    .shadow(radius: 2, y: 1)
                    .offset(x: size * 0.30, y: size * 0.30)
            }
        }
        .frame(width: size, height: size)
        .accessibilityLabel("MUSE, der Papier-Fuchs")
        .accessibilityHint("Zeigt Stimmung und Bereich als Icon an.")
    }
}

// kleine Hex-Color-Hilfe
private extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red:   Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >>  8) & 0xFF) / 255.0,
            blue:  Double((hex >>  0) & 0xFF) / 255.0,
            opacity: alpha
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        MascotView(mood: .freude, domain: .leisure)
        MascotView(mood: .traurig, domain: .work)
        MascotView(mood: .unsicher, domain: .privateLife)
        MascotView(mood: .enttaeuscht, domain: nil)
        MascotView(mood: nil, domain: nil)
    }
    .padding()
    .preferredColorScheme(.dark)
}
