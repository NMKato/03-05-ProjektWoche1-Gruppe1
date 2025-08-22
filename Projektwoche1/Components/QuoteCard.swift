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
            
            
            VStack {
                Spacer()
                Image("blaetterBoden03")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 370, maxHeight: 200)  // Flexible Breite
                    .opacity(0.7)
                    .clipped()  // Verhindert Overflow
                    
            }
           .allowsHitTesting(false)
            
            
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
        .sheet(isPresented: $viewModel.showShareSheet) {
            ShareSheet(content: viewModel.shareContent)
        }
    }
}

// MARK: - Subviews
private extension QuoteCard {
    
    @ViewBuilder
    var header: some View {
        if viewModel.config.showCategoryBadge, let category = viewModel.quote.category {
            HStack {
                HStack(spacing: 8) {
                    Image(category.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .padding(2)
                        .background(Color.white.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    Text(category.displayName)
                        .font(.caption.weight(.semibold))
                }
                
                Spacer()
                
                // Rechte Seite: Share Button
                if viewModel.config.showActions {
                    Button {
                        viewModel.shareQuote()
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.bordered)
                    .accessibilityLabel("Zitat teilen")
                }
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
                // Blattbutton
                Button {
                    viewModel.refreshQuote()
                } label: {
                    ZStack {
                        // Hintergrund: Blatt PNG
                        Image("blattButton02")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .rotationEffect(.degrees(15))
                        
                        // Vordergrund: SF Symbol (liegt darüber)
                        if viewModel.isPerformingAction {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }
                }
                .disabled(!viewModel.canRefresh)
                
                Spacer(minLength: 150)
                // Favorite Button
                Button {
                    viewModel.toggleFavorite()
                } label: {
                    Label(viewModel.favoriteButtonLabel, systemImage: viewModel.favoriteButtonIcon)
                        .labelStyle(.iconOnly)
                        .foregroundColor(.yellow)
                    
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
            return [Color.orange.opacity(0.60), Color.red.opacity(0.5)]
        case .wisdom:
            return [Color.blue.opacity(0.6), Color.indigo.opacity(0.6)]
        case .programming:
            return [Color.green.opacity(0.5), Color.teal.opacity(0.4)]
        case .general:
            return [Color.gray.opacity(0.3), Color.gray.opacity(0.6)]
        case .drinking:
            return [Color.yellow.opacity(0.7), Color.orange.opacity(0.4)]
        case .mindset:
            return [Color.purple.opacity(0.60), Color.blue.opacity(0.3)]
        case .none:
            return [Color.gray.opacity(0.5), Color.gray.opacity(0.7)]
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

// MARK: - ShareSheet Helper
private struct ShareSheet: UIViewControllerRepresentable {
    let content: String
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityVC = UIActivityViewController(
            activityItems: [content],
            applicationActivities: nil
        )
        return activityVC
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Keine Updates benötigt
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
