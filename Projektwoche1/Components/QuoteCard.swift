//
//  QuoteCard.swift
//  Projektwoche1
//
//  Created by Florica Girisci on 19.08.25.
//  Überarbeitet: ViewModel-basiert, saubere Modiferkette, optionales Blatt-Overlay
//

import SwiftUI

struct QuoteCard: View {

    // MARK: - Konfiguration

    struct Config {
        var showCategoryBadge: Bool = true
        var showActions: Bool = true
        var cornerRadius: CGFloat = 20
        var padding: CGFloat = 16
        var maxWidth: CGFloat? = 640
        var showLeafOverlay: Bool = true     // NEU: Blatt-Overlay steuerbar
        
        // gezielte Steuerung NUR für diese Card-Instanz
            var headerIconSize: CGFloat = 40                 // Kategorie-Icon links oben
            var titleFontOverride: Font? = nil               // Zitat-Text
            var authorFontOverride: Font? = nil              // Autor/-in
        
        var titleMinScaleFactor: CGFloat? = nil   // nil ⇒ Standardverhalten
        var authorMinScaleFactor: CGFloat? = nil
    }

    enum BackgroundStyle: Equatable {
        case categoryGradient(Category?)
        case asset(name: String)
        case url(_ string: String) // Platzhalter für künftiges Remote-Image
    }

    // MARK: - ViewModel

    @ObservedObject var viewModel: QuoteCardViewModel

    // MARK: - View

    var body: some View {
        // Card-Inhalt als ein zusammenhängender View
        ZStack(alignment: .topLeading) {

            // Hintergrund
            backgroundLayer

            // Inhalt
            VStack(alignment: .leading, spacing: 12) {
                header
                bodyText
                footer
            }
            .padding(viewModel.config.padding)

            // Optionales Blatt-Overlay (liegt ganz unten)
            if viewModel.config.showLeafOverlay {
                VStack {
                    Spacer()
                    Image("blaetterBoden03")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 370, maxHeight: 200)
                        .opacity(0.7)
                        .clipped()
                }
                .allowsHitTesting(false)
            }
        }
        // Rahmen/Maskierung/Schlagschatten für die gesamte Karte
        .frame(maxWidth: viewModel.config.maxWidth, alignment: .leading)
        .clipShape(RoundedRectangle(cornerRadius: viewModel.config.cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: viewModel.config.cornerRadius, style: .continuous)
                .strokeBorder(.white.opacity(0.08))
        )
        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)

        // A11y & Fehlerdarstellung
        .accessibilityElement(children: .combine)
        .accessibilityLabel(viewModel.accessibilityLabel)
        .alert("Fehler", isPresented: Binding(
            get: { viewModel.actionError != nil },
            set: { if !$0 { viewModel.clearError() } }
        )) {
            Button("OK") { viewModel.clearError() }
        } message: {
            Text(viewModel.actionError ?? "")
        }

        // Share-Sheet (Bild/Items)
        .sheet(isPresented: $viewModel.showShareSheet) {
            ShareSheet(items: viewModel.shareItems)
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
                        .frame(width: 80, height: 80)
                        .padding(2)
                        .background(Color.white.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    Text(category.displayName)
                        .font(.headline.weight(.semibold))
                }

                Spacer()

                if viewModel.config.showActions {
                    Button {
                        viewModel.shareDesignedQuote()
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
                .font(.title.weight(.semibold))
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

                // Refresh (Blatt-Button)
                Button {
                    viewModel.refreshQuote()
                } label: {
                    ZStack {
                        Image("blattButton02")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .rotationEffect(.degrees(15))

                        if viewModel.isPerformingAction {
                            ProgressView().scaleEffect(0.8)
                        } else {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }
                }
                .disabled(!viewModel.canRefresh)

                Spacer(minLength: 150)

                // Favorit
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

                // Fallback, wenn das Asset fehlt
                LinearGradient(
                    colors: [Color.gray.opacity(0.4), Color.gray.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .blendMode(.destinationOver)
            }

        case .url:
            // Platzhalter für Remote-Bilder
            LinearGradient(
                colors: [Color.gray.opacity(0.4), Color.gray.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    /// Gradient nach Kategorie
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

// MARK: - Convenience Initializer

extension QuoteCard {
    init(
        quote: Quote,
        dataManager: DataManager,
        quoteService: QuoteService? = nil,
        config: Config = .init(),
        backgroundStyle: BackgroundStyle = .categoryGradient(nil)
    ) {
        let vm = QuoteCardViewModel(
            quote: quote,
            dataManager: dataManager,
            quoteService: quoteService,
            config: config,
            backgroundStyle: backgroundStyle
        )
        self.viewModel = vm
    }
}

// MARK: - ShareSheet Helper

private struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Preview

#Preview {
    let container = SwiftDataConfigurator.createPreviewContainer()
    let dataManager = DataManager(modelContext: container.mainContext)
    let quoteService = QuoteService()

    let sampleQuote = Quote(
        text: "Die beste Möglichkeit die Zukunft vorherzusagen ist sie zu gestalten.",
        author: "Abraham Lincoln",
        category: .motivation
    )

    let vm = QuoteCardViewModel(
        quote: sampleQuote,
        dataManager: dataManager,
        quoteService: quoteService,
        config: .init(),
        backgroundStyle: .categoryGradient(.motivation)
    )

    return QuoteCard(viewModel: vm)
        .preferredColorScheme(.dark)
        .padding()
        .modelContainer(container)
}
