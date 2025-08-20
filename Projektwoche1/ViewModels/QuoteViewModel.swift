//
//  QuoteViewModel.swift
//  Projektwoche1
//
//  Created by Nikolas Kato on 18.08.25.
//

import Foundation
import SwiftUI

// MARK: - QuoteViewModel
/// ViewModel für die Hauptansicht der QuoteCraft App
/// Verwaltet aktuelles Zitat, UI-State und Benutzerinteraktionen
@MainActor
final class QuoteViewModel: ObservableObject {
    
    // MARK: - Published Properties (Quote-bezogen)
    
    /// Das aktuell angezeigte Zitat
    @Published var currentQuote: Quote?
    
    /// Loading-Status für UI-Feedback
    @Published var isLoading: Bool = false
    
    /// Fehlermeldung für Benutzer-Feedback
    @Published var errorMessage: String?
    
    /// Status ob aktuelles Zitat favorisiert ist
    @Published var isFavorited: Bool = false
    
    /// Aktuell ausgewählte Kategorie für Filterung (nil = alle)
    @Published var selectedCategory: Category?
    
    // MARK: - Published Properties (UI-State) - NEU
    
    /// Aktuell ausgewählte Stimmung des Benutzers
    @Published var selectedMood: Mood = .freude
    
    /// Aktuell ausgewählter Lebensbereich
    @Published var selectedDomain: LifeDomain = .work
    
    /// Status ob Favoriten-Sheet angezeigt wird
    @Published var showFavorites: Bool = false
    
    // MARK: - Private Properties
    
    /// DataManager für SwiftData-Operationen
    private let dataManager: DataManager
    
    /// QuoteService für Zitat-Bereitstellung
    private let quoteService: QuoteService
    
    // MARK: - Initializer
    
    /// Initialisiert das ViewModel mit benötigten Dependencies
    /// - Parameter dataManager: DataManager für Datenpersistierung
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        self.quoteService = QuoteService()
    }
    
    // MARK: - Public Methods (Quote-Operationen)
    
    /// Lädt ein zufälliges Zitat beim App-Start
    /// Wird von ContentView beim onAppear aufgerufen
    func loadRandomQuote() {
        Task {
            await performQuoteLoad {
                let quote = self.quoteService.getRandomQuote()
                await self.setCurrentQuote(quote)
            }
        }
    }
    
    /// Lädt ein neues Zitat basierend auf aktueller Stimmung und Bereich
    /// Verwendet selectedMood und selectedDomain für personalisierte Auswahl
    func refreshQuote() {
        Task {
            await performQuoteLoad {
                let quote = self.quoteService.getQuote(
                    mood: self.selectedMood,
                    domain: self.selectedDomain
                )
                await self.setCurrentQuote(quote)
            }
        }
    }
    
    /// Lädt ein zufälliges Zitat aus einer bestimmten Kategorie
    /// - Parameter category: Die gewünschte Kategorie (nil für alle)
    func loadQuotesByCategory(_ category: Category?) {
        selectedCategory = category
        Task {
            await performQuoteLoad {
                let quote: Quote
                if let selectedCategory = category {
                    let categoryQuotes = self.quoteService.getQuotesByCategory(selectedCategory)
                    quote = categoryQuotes.randomElement() ?? self.quoteService.getRandomQuote()
                } else {
                    quote = self.quoteService.getRandomQuote()
                }
                await self.setCurrentQuote(quote)
            }
        }
    }
    
    /// Togglet den Favoriten-Status des aktuellen Zitats
    /// Fügt zu Favoriten hinzu oder entfernt es
    func toggleFavorite() {
        guard let currentQuote = currentQuote else { return }
        
        Task {
            do {
                if isFavorited {
                    try dataManager.removeFromFavorites(currentQuote)
                    await updateFavoriteStatus(false)
                } else {
                    try dataManager.addToFavorites(currentQuote)
                    await updateFavoriteStatus(true)
                }
                
                await clearError()
                
            } catch {
                await handleError(error)
            }
        }
    }
    
    /// Prüft ob das aktuelle Zitat favorisiert ist
    /// Wird aufgerufen wenn sich currentQuote ändert
    func checkFavoriteStatus() {
        guard let currentQuote = currentQuote else {
            isFavorited = false
            return
        }
        
        Task {
            let favorited = dataManager.isQuoteFavorited(currentQuote)
            await updateFavoriteStatus(favorited)
        }
    }
    
    /// Löscht die aktuelle Fehlermeldung
    /// Wird von UI-Elementen aufgerufen um Fehler zu dismissen
    func clearError() async {
        await MainActor.run {
            errorMessage = nil
        }
    }
    
    // MARK: - Public Methods (UI-State Management) - NEU
    
    /// Aktualisiert Stimmung und lädt passendes Zitat
    /// - Parameter mood: Die neue Stimmung
    func updateMood(_ mood: Mood) {
        selectedMood = mood
        refreshQuote() // Automatisch neues Zitat basierend auf neuer Stimmung
    }
    
    /// Aktualisiert Lebensbereich und lädt passendes Zitat
    /// - Parameter domain: Der neue Lebensbereich
    func updateDomain(_ domain: LifeDomain) {
        selectedDomain = domain
        refreshQuote() // Automatisch neues Zitat basierend auf neuem Bereich
    }
    
    /// Aktualisiert sowohl Stimmung als auch Bereich
    /// - Parameters:
    ///   - mood: Die neue Stimmung
    ///   - domain: Der neue Lebensbereich
    func updateMoodAndDomain(mood: Mood, domain: LifeDomain) {
        selectedMood = mood
        selectedDomain = domain
        refreshQuote()
    }
    
    /// Zeigt Favoriten-Sheet an
    func showFavoritesSheet() {
        showFavorites = true
    }
    
    /// Versteckt Favoriten-Sheet
    func hideFavoritesSheet() {
        showFavorites = false
    }
    
    /// Togglet Favoriten-Sheet Anzeige
    func toggleFavoritesSheet() {
        showFavorites.toggle()
    }
}

// MARK: - Private Helper Methods
private extension QuoteViewModel {
    
    /// Führt eine Zitat-Lade-Operation mit Loading-Status aus
    /// - Parameter operation: Die auszuführende async Operation
    func performQuoteLoad(_ operation: @escaping () async -> Void) async {
        await setLoading(true)
        await clearError()
        
        do {
            await operation()
        } catch {
            await handleError(error)
        }
        
        await setLoading(false)
    }
    
    /// Setzt das aktuelle Zitat und prüft Favoriten-Status
    /// - Parameter quote: Das neue aktuelle Zitat
    func setCurrentQuote(_ quote: Quote) async {
        await MainActor.run {
            self.currentQuote = quote
        }
        
        // Prüfe Favoriten-Status für das neue Zitat
        checkFavoriteStatus()
    }
    
    /// Aktualisiert den Loading-Status
    /// - Parameter loading: Neuer Loading-Status
    func setLoading(_ loading: Bool) async {
        await MainActor.run {
            isLoading = loading
        }
    }
    
    /// Aktualisiert den Favoriten-Status
    /// - Parameter favorited: Neuer Favoriten-Status
    func updateFavoriteStatus(_ favorited: Bool) async {
        await MainActor.run {
            isFavorited = favorited
        }
    }
    
    /// Behandelt Fehler und zeigt benutzerfreundliche Nachricht
    /// - Parameter error: Der aufgetretene Fehler
    func handleError(_ error: Error) async {
        await MainActor.run {
            if let dataError = error as? DataManagerError {
                errorMessage = dataError.errorDescription
            } else {
                errorMessage = "Ein unerwarteter Fehler ist aufgetreten: \(error.localizedDescription)"
            }
        }
    }
}

// MARK: - Computed Properties für UI
extension QuoteViewModel {
    
    /// Zeigt ob ein Zitat geladen ist
    var hasQuote: Bool {
        currentQuote != nil
    }
    
    /// Zeigt ob gerade ein Loading-Vorgang läuft
    var isIdle: Bool {
        !isLoading
    }
    
    /// Zeigt ob ein Fehler vorliegt
    var hasError: Bool {
        errorMessage != nil
    }
    
    /// Formatierte Anzeige der aktuellen Auswahl
    var currentSelectionText: String {
        "\(selectedMood.displayName) • \(selectedDomain.displayName)"
    }
    
    /// Zeigt ob Favoriten-Button verfügbar ist
    var canToggleFavorite: Bool {
        hasQuote && isIdle
    }
    
    /// Zeigt ob Refresh-Button verfügbar ist
    var canRefresh: Bool {
        isIdle
    }
}
