//
//  QuoteCardViewModel.swift
//  Projektwoche1
//
//  Created by Nikolas Kato on 20.08.25.
//

import Foundation
import SwiftUI

// MARK: - QuoteCardViewModel
/// ViewModel für QuoteCard - kapselt alle Card-spezifische Logik
/// Trennt UI von Business-Logik für bessere Testbarkeit
@MainActor
final class QuoteCardViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Das angezeigte Zitat
    @Published var quote: Quote
    
    @Published var shareItems: [Any] = []
    
  

    
    /// Favoriten-Status des Zitats
    @Published var isFavorited: Bool
    
    /// Loading-State für Aktionen
    @Published var isPerformingAction: Bool = false
    
    /// Share-Sheet Anzeige-Status
    @Published var showShareSheet: Bool = false

    /// Zu teilender Inhalt
    @Published var shareContent: String = ""
    
    /// Fehlermeldung bei Aktionen
    @Published var actionError: String?
    
    // MARK: - Configuration
    
    /// Konfiguration für die Card-Anzeige
    let config: QuoteCard.Config
    
    /// Background-Style der Card
    let backgroundStyle: QuoteCard.BackgroundStyle
    
    // MARK: - Dependencies
    
    /// DataManager für Favoriten-Operationen
    private let dataManager: DataManager
    
    /// QuoteService für neue Zitate
    private let quoteService: QuoteService
    
    // MARK: - Callbacks
    
    /// Callback für externe Refresh-Aktionen
    var onQuoteRefreshed: ((Quote) -> Void)?
    
    /// Callback für Favoriten-Änderungen
    var onFavoriteChanged: ((Quote, Bool) -> Void)?
    
    // MARK: - Initializer
    
    /// Initialisiert ViewModel mit Quote und Dependencies
    /// - Parameters:
    ///   - quote: Das anzuzeigende Quote
    ///   - dataManager: DataManager für Persistierung
    ///   - quoteService: Service für neue Zitate (optional für Favoriten-Listen)
    ///   - config: UI-Konfiguration
    ///   - backgroundStyle: Background der Card
    init(
        quote: Quote,
        dataManager: DataManager,
        quoteService: QuoteService? = nil,
        config: QuoteCard.Config = .init(),
        backgroundStyle: QuoteCard.BackgroundStyle = .categoryGradient(nil)
    ) {
        self.quote = quote
        self.dataManager = dataManager
        self.quoteService = quoteService ?? QuoteService()
        self.config = config
        self.backgroundStyle = backgroundStyle
        self.isFavorited = dataManager.isQuoteFavorited(quote)
    }
    
    // MARK: - Public Actions
    
    /// Lädt ein neues zufälliges Zitat
    /// Nur verfügbar wenn QuoteService injiziert wurde
    func refreshQuote() {
        guard config.showActions else { return }
        
        Task {
            await performAction {
                let newQuote = self.quoteService.getRandomQuote()
                await self.updateQuote(newQuote)
                await MainActor.run {
                    self.onQuoteRefreshed?(newQuote)
                    // Benachrichtige andere Views über neues Zitat
                    NotificationCenter.default.post(
                        name: .init("QuoteRefreshed"),
                        object: newQuote
                    )
                }
            }
        }
    }
    
    /// Togglet den Favoriten-Status
    func toggleFavorite() {
        guard config.showActions else { return }
        
        Task {
            await performAction {
                if self.isFavorited {
                    try self.dataManager.removeFromFavorites(self.quote)
                    await self.updateFavoriteStatus(false)
                } else {
                    try self.dataManager.addToFavorites(self.quote)
                    await self.updateFavoriteStatus(true)
                }
                
                await MainActor.run {
                    self.onFavoriteChanged?(self.quote, self.isFavorited)
                    // Benachrichtige andere Views über Favoriten-Änderung
                    NotificationCenter.default.post(
                        name: .init("FavoriteChanged"),
                        object: nil,
                        userInfo: [
                            "quote": self.quote,
                            "isFavorited": self.isFavorited
                        ]
                    )
                }
            }
        }
    }
    
   

    @MainActor
    func shareDesignedQuote() {
        guard config.showActions else { return }

        let targetSize = CGSize(width: 1024, height: 1024)

        let canvas = ShareQuoteView(
            text: quote.text,
            author: quote.author,
            category: quote.category,
            backgroundAsset: "MUSE_Share_Design",
            canvasSize: targetSize
        )

        if let image = ShareRenderer.render(view: canvas, size: targetSize) {
            let caption = "„\(quote.text)“\n— \(quote.author)"
            self.shareItems = [image, caption]
            self.showShareSheet = true
        } else {
            self.shareItems = ["„\(quote.text)“\n— \(quote.author)"]
            self.showShareSheet = true
        }
    }

    
  
    
    /// Aktualisiert das Quote (für externe Updates)
    /// - Parameter newQuote: Das neue Quote
    func updateQuote(_ newQuote: Quote) async {
        await MainActor.run {
            self.quote = newQuote
            self.isFavorited = self.dataManager.isQuoteFavorited(newQuote)
        }
    }
    
    /// Löscht aktuelle Fehlermeldung
    func clearError() {
        actionError = nil
    }
}

// MARK: - Private Helper Methods
private extension QuoteCardViewModel {
    
    /// Führt eine Aktion mit Loading-State und Error-Handling aus
    /// - Parameter action: Die auszuführende async Aktion
    func performAction(_ action: @escaping () async throws -> Void) async {
        await setLoading(true)
        await clearActionError()
        
        do {
            try await action()
        } catch {
            await handleActionError(error)
        }
        
        await setLoading(false)
    }
    
    /// Setzt Loading-Status
    /// - Parameter loading: Neuer Loading-Status
    func setLoading(_ loading: Bool) async {
        await MainActor.run {
            self.isPerformingAction = loading
        }
    }
    
    /// Aktualisiert Favoriten-Status
    /// - Parameter favorited: Neuer Favoriten-Status
    func updateFavoriteStatus(_ favorited: Bool) async {
        await MainActor.run {
            self.isFavorited = favorited
        }
    }
    
    /// Löscht Aktions-Fehler
    func clearActionError() async {
        await MainActor.run {
            self.actionError = nil
        }
    }
    
    /// Behandelt Aktions-Fehler
    /// - Parameter error: Der aufgetretene Fehler
    func handleActionError(_ error: Error) async {
        await MainActor.run {
            if let dataError = error as? DataManagerError {
                self.actionError = dataError.errorDescription
            } else {
                self.actionError = "Aktion fehlgeschlagen: \(error.localizedDescription)"
            }
        }
    }
}

// MARK: - Computed Properties für UI
extension QuoteCardViewModel {
    
    /// Formatierter Text für Accessibility
    var accessibilityLabel: String {
        "Zitat von \(quote.author): \(quote.text)"
    }
    
    /// Icon für Favoriten-Button
    var favoriteButtonIcon: String {
        isFavorited ? "star.fill" : "star"
    }
    
    /// Label für Favoriten-Button
    var favoriteButtonLabel: String {
        isFavorited ? "Aus Favoriten entfernen" : "Zu Favoriten hinzufügen"
    }
    
    /// Zeigt ob Refresh-Button verfügbar ist
    var canRefresh: Bool {
        config.showActions && !isPerformingAction
    }
    
    /// Zeigt ob Favoriten-Button verfügbar ist
    var canToggleFavorite: Bool {
        config.showActions && !isPerformingAction
    }
}



