//
//  QuoteCard.swift
//  Projektwoche1
//
//  Created by Florica Girisci on 19.08.25.
//

import SwiftUI

struct QuoteCard: View {
    //MARK: - Konfiguration
    
    struct Config {
        var showCategoryBadge: Bool = true
        var showActions: Bool = true
        var cornerRadius: CGFloat = 20
        var padding: CGFloat = 16
        var maxWidth: CGFloat? = 640
        
    }
    enum BackgroundStyle: Equatable {
        case categoryGradient(Category?)
        case asset(name: String)
        case url(_ string: String)
        
    }
    //MARK: - Input
    
    let quoteText: String
    let author: String
    let category: Category?
    let background: BackgroundStyle
    var config: Config = .init()
    
    // Actions werden von außen initiert
    
    var onRefresh: (() -> Void)?
    var onToggleFavorite: (() -> Void)?
    var isFavorited: Bool = false
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            // hintergrund Bild
            backgroundLayer
            
            // Inhalt
            VStack(alignment: .leading, spacing: 12) {
               header
               bodyText
               footer
                }
            .padding(config.padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            }
        .frame(maxWidth: config.maxWidth)
        .clipShape(RoundedRectangle(cornerRadius: config.cornerRadius, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: config.cornerRadius, style: .continuous)
            .strokeBorder(.white.opacity(0.08)))
        .shadow(radius: 8, y: 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Zitat von \(author). \(quoteText)")
        
            
        }
    }
       
    // MARK: - Subviews
private extension QuoteCard {
    @ViewBuilder
    var header: some View {
        if config.showCategoryBadge, let cat = category {
            HStack {
                Text("\(cat.icon)  \(cat.displayName)")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                Spacer()
                
            }
            .transition(.opacity.combined(with: .move(edge: .top)))
            
        }
    }
    var bodyText: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(quoteText)")
                .font(.title2.weight(.semibold))
                .minimumScaleFactor(0.9)
                .multilineTextAlignment(.leading)
            
            Text(" - \(author) - ")
                .font(.subheadline)
                .foregroundStyle(.white)
            
            
        }
        .foregroundStyle(.primary)
    }
    
    @ViewBuilder
    var footer: some View {
        if config.showActions {
            HStack(spacing: 10) {
                Button {
                    onRefresh?()
                } label: {
                    Label("Neues Zitat", systemImage: ".arrow.clockwise")
                }
                .buttonStyle(.borderedProminent)
                
                
                Button {
                    onToggleFavorite?()
                } label: {
                    Label(isFavorited ? "" : "Favorite", systemImage: isFavorited ? "star.fill" : "star")
                }
                
                .buttonStyle(.bordered)
                .foregroundStyle(.white)
                
                Spacer()
            }
            .padding(.top, 6)
        }
    }
    @ViewBuilder
        
        var backgroundLayer: some View {
            
            switch background {
            case .categoryGradient(let cat): LinearGradient(colors: gradientColors(for: cat), startPoint: .topTrailing, endPoint: .bottomTrailing)
                    .overlay(LinearGradient(colors: [Color.black.opacity(0.25), Color.black.opacity(0.05)], startPoint: .bottom, endPoint: .top))
            case .asset(let name):
                ZStack {
                    Image(name)
                        .resizable()
                        .scaledToFill()
                        .overlay(Color.black.opacity(0.25))
                    // fallback falls assets fehlt
                    LinearGradient(colors: [Color.gray.opacity(0.4), Color.gray.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .blendMode(.destinationOver)
                }
            case .url:
                // platzhalter für spätere Erweiterung mit Image (fallback)
                LinearGradient(colors: [Color.gray.opacity(0.4), Color.gray.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing)
                
                
                
            }
        }
        func gradientColors(for cat: Category?) -> [Color] {
            switch cat {
            case .motivation: return [Color.orange.opacity(0.85), Color.red.opacity(0.7)]
            case .wisdom: return [Color.blue.opacity(0.8), Color.indigo.opacity(0.7)]
            case .programming: return [Color.green.opacity(0.8), Color.teal.opacity(0.7)]
            case .general: return [Color.gray.opacity(0.6), Color.gray.opacity(0.8)]
            case .drinking: return [Color.yellow.opacity(0.9), Color.orange.opacity(0.7)]
            case .mindset: return [Color.purple.opacity(0.85), Color.blue.opacity(0.6)]
            case .none: return [Color.gray.opacity(0.6), Color.gray.opacity(0.8)]
                
            }
        }
    }
    
    
    // MARK - Preview
    #Preview {
        QuoteCard(quoteText: "Die beste Möglichkeit die Zukunft vorherzusagen ist sie zu gestalten.", author: "Abraham Lincoln", category: .motivation, background: .categoryGradient(.motivation), config: .init())
            .preferredColorScheme(.dark)
            .padding()
    }
    


