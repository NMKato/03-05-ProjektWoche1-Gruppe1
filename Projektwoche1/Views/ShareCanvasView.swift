import SwiftUI

/// Quadratisches Share-Canvas (1024×1024) im 1:1 App-Look.
struct ShareCanvasView: View {
    let quote: Quote
    let dataManager: DataManager

    /// Zielgröße des Bildexports
    var canvasSize: CGSize = .init(width: 1024, height: 1024)

    /// App-Hintergrund (ohne zusätzliche Tönung)
    var backgroundAsset: String = "MUSE_Share_Design"

    /// Wie viel der Fläche die Karte nutzen darf
    var contentWidthRatio: CGFloat  = 0.92
    var contentHeightRatio: CGFloat = 0.92

    /// Textvergrößerung via Dynamic Type (wirkt nur auf Schrift, nicht auf Layoutrahmen)
    var textBoost: DynamicTypeSize = .accessibility2 // .accessibility1–5 möglich

    var body: some View {
        ZStack {
            // 1) Hintergrund 1:1 wie in der App
            Image(backgroundAsset)
                .resizable()
                .scaledToFill()
                .frame(width: canvasSize.width, height: canvasSize.height)
                .clipped()
                .ignoresSafeArea()
            
            // 2) Original-QuoteCard – Blätter & Aktionen AUS
            QuoteCard(
                quote: quote,
                dataManager: dataManager,
                quoteService: nil,
                config: .init(
                    showCategoryBadge: true,
                    showActions: false,
                    cornerRadius: 28,
                    padding: 24,
                    maxWidth: canvasSize.width * contentWidthRatio,
                    showLeafOverlay: false,                         // Blätter aus
                    headerIconSize: 100,                             // ← Icon größer (z. B. 64)
                    titleFontOverride: .system(size: 60, weight: .semibold, design: .rounded),  // ← Zitat größer
                    authorFontOverride: .system(size: 30, weight: .regular, design: .rounded)   // ← Autor größer
                ),
                backgroundStyle: .categoryGradient(quote.category)
            )
            
            // Text gezielt größer, Layout bleibt stabil
        }
        .frame(width: 350, height: 300)
        .preferredColorScheme(.dark)
    }
}

extension ShareCanvasView {
    init(quote: Quote,
         dataManager: DataManager,
         canvasSize: CGSize,
         templateAsset: String,
         desiredScale: CGFloat,
         contentWidthRatio: CGFloat,
         contentHeightRatio: CGFloat,
         estimatedCardAspect: CGFloat)
    {
        self.init(
            quote: quote,
            dataManager: dataManager,
            canvasSize: canvasSize,
            backgroundAsset: templateAsset, // Mapping
            contentWidthRatio: contentWidthRatio,
            contentHeightRatio: contentHeightRatio,
            textBoost: .accessibility2       // nutzen Sie Boost statt Scale
        )
    }
}
