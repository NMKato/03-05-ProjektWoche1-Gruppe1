//
//  QuoteCard.swift
//  Projektwoche1
//
//  Created by Florica Girisci on 19.08.25.
//  Überarbeitet: ViewModel basiert für bessere Trennung

import SwiftUI

struct QuoteCard: View {
    
    // MARK: - Konfiguration
    
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
    
    // MARK: - ViewModel
    
    /// ViewModel das die komplette Card-Logik kapselt
    @ObservedObject var viewModel: QuoteCardViewModel
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            // Hintergrund Bild
            backgroundLayer
            
            // Inhalt
            VStack(alignment: .leading, spacing: 12) {
                header
                bodyText
                footer
            }
            .padding(viewModel.config.padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .frame(maxWidth: viewModel.config.maxWidth)
        .clipShape(RoundedRectangle(cornerRadius: viewModel.config.cornerRadius, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: viewModel.config.cornerRadius, style: .continuous)
            .strokeBorder(.white.opacity(0.08)))
        .shadow(radius: 8, y: 4)
        
        .accessibilityElement(children: .combine)
        .accessibilityLabel(viewModel.accessibilityLabel)
        .alert("Fehler", isPresented: .constant(viewModel.actionError != nil)) {
            Button("OK") { viewModel.clearError() }
        } message: {
            if let error = viewModel.actionError {
                Text(error)
            }
        }
    }
}

// MARK: - Subviews
private extension QuoteCard {
    
    @ViewBuilder
    var header: some View {
        if viewModel.config.showCategoryBadge, let category = viewModel.quote.category {
            HStack {
                Text("\(category.icon)  \(category.displayName)")
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
            Text(viewModel.quote.text)
                .font(.title2.weight(.semibold))
                .minimumScaleFactor(0.9)
                .multilineTextAlignment(.leading)
            
            Text(" - \(viewModel.quote.author) - ")
                .font(.subheadline)
                .foregroundStyle(.white)
        }
        .foregroundStyle(.primary)
    }
    
    @ViewBuilder
    var footer: some View {
        if viewModel.config.showActions {
            HStack(spacing: 10) {
                // Refresh Button
                Button {
                    viewModel.refreshQuote()
                } label: {
                    HStack(spacing: 4) {
                        if viewModel.isPerformingAction {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "arrow.clockwise")
                        }
                        Text("Neues Zitat")
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.canRefresh)
                
                // Favorite Button
                Button {
                    viewModel.toggleFavorite()
                } label: {
                    Label(viewModel.favoriteButtonLabel, systemImage: viewModel.favoriteButtonIcon)
                        .labelStyle(.iconOnly)
                }
                .buttonStyle(.bordered)
                .foregroundStyle(.white)
                .disabled(!viewModel.canToggleFavorite)
                .accessibilityLabel(viewModel.favoriteButtonLabel)
                
                Spacer()
            }
            .padding(.top, 6)
        }
    }
    
    @ViewBuilder
    var backgroundLayer: some View {
        switch viewModel.backgroundStyle {
        case .categoryGradient(let category):
            LinearGradient(
                colors: gradientColors(for: category),
                startPoint: .topTrailing,
                endPoint: .bottomTrailing
            )
            .overlay(
                LinearGradient(
                    colors: [Color.black.opacity(0.25), Color.black.opacity(0.05)],
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
            
        case .asset(let name):
            ZStack {
                Image(name)
                    .resizable()
                    .scaledToFill()
                    .overlay(Color.black.opacity(0.25))
                
                // Fallback falls Asset fehlt
                LinearGradient(
                    colors: [Color.gray.opacity(0.4), Color.gray.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .blendMode(.destinationOver)
            }
            
        case .url:
            // Platzhalter für spätere Erweiterung mit Remote Images
            LinearGradient(
                colors: [Color.gray.opacity(0.4), Color.gray.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    /// Bestimmt Gradient-Farben basierend auf Kategorie
    /// - Parameter category: Die Zitat-Kategorie
    /// - Returns: Array von Farben für den Gradient
    func gradientColors(for category: Category?) -> [Color] {
        switch category {
        case .motivation:
            return [Color.orange.opacity(0.85), Color.red.opacity(0.7)]
        case .wisdom:
            return [Color.blue.opacity(0.8), Color.indigo.opacity(0.7)]
        case .programming:
            return [Color.green.opacity(0.8), Color.teal.opacity(0.7)]
        case .general:
            return [Color.gray.opacity(0.6), Color.gray.opacity(0.8)]
        case .drinking:
            return [Color.yellow.opacity(0.9), Color.orange.opacity(0.7)]
        case .mindset:
            return [Color.purple.opacity(0.85), Color.blue.opacity(0.6)]
        case .none:
            return [Color.gray.opacity(0.6), Color.gray.opacity(0.8)]
        }
    }
}

// MARK: - Convenience Initializers
extension QuoteCard {
    
    /// Convenience Initializer für einfache Verwendung ohne ViewModel-Erstellung
    /// - Parameters:
    ///   - quote: Das anzuzeigende Quote
    ///   - dataManager: DataManager für Favoriten-Operationen
    ///   - quoteService: QuoteService für Refresh-Funktionalität
    ///   - config: UI-Konfiguration
    ///   - backgroundStyle: Background-Style
    init(
        quote: Quote,
        dataManager: DataManager,
        quoteService: QuoteService? = nil,
        config: Config = .init(),
        backgroundStyle: BackgroundStyle = .categoryGradient(nil)
    ) {
        let viewModel = QuoteCardViewModel(
            quote: quote,
            dataManager: dataManager,
            quoteService: quoteService,
            config: config,
            backgroundStyle: backgroundStyle
        )
        self.viewModel = viewModel
    }
}

// MARK: - Preview
#Preview {
    // Preview mit neuem ViewModel-basierten Ansatz
    let container = SwiftDataConfigurator.createPreviewContainer()
    let dataManager = DataManager(modelContext: container.mainContext)
    let quoteService = QuoteService()
    
    let sampleQuote = Quote(
        text: "Die beste Möglichkeit die Zukunft vorherzusagen ist sie zu gestalten.",
        author: "Abraham Lincoln",
        category: .motivation
    )
    
    let viewModel = QuoteCardViewModel(
        quote: sampleQuote,
        dataManager: dataManager,
        quoteService: quoteService,
        config: .init(),
        backgroundStyle: .categoryGradient(.motivation)
    )
    
    return QuoteCard(viewModel: viewModel)
        .preferredColorScheme(.dark)
        .padding()
        .modelContainer(container)
}
