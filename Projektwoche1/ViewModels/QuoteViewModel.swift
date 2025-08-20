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
/// Verwaltet aktuelles Zitat und Benutzerinteraktionen
@MainActor
final class QuoteViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
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
    
    // MARK: - Public Methods
    
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
    
    /// Lädt ein neues zufälliges Zitat (Button-Aktion)
    /// Unterscheidet sich von loadRandomQuote durch UI-Feedback
    func refreshQuote() {
        Task {
            await performQuoteLoad {
                let quote: Quote
                if let selectedCategory = self.selectedCategory {
                    // Lade Zitat aus gewählter Kategorie
                    let categoryQuotes = self.quoteService.getQuotesByCategory(selectedCategory)
                    quote = categoryQuotes.randomElement() ?? self.quoteService.getRandomQuote()
                } else {
                    // Lade zufälliges Zitat aus allen Kategorien
                    quote = self.quoteService.getRandomQuote()
                }
                await self.setCurrentQuote(quote)
            }
        }
    }
    
    /// Lädt ein zufälliges Zitat aus einer bestimmten Kategorie
    /// - Parameter category: Die gewünschte Kategorie (nil für alle)
    func loadQuotesByCategory(_ category: Category?) {
        selectedCategory = category
        refreshQuote()
    }
    
    /// Togglet den Favoriten-Status des aktuellen Zitats
    /// Fügt zu Favoriten hinzu oder entfernt es
    func toggleFavorite() {
        guard let currentQuote = currentQuote else { return }
        
        Task {
            do {
                if isFavorited {
                    // Entferne von Favoriten
                    try dataManager.removeFromFavorites(currentQuote)
                    await updateFavoriteStatus(false)
                } else {
                    // Füge zu Favoriten hinzu
                    try dataManager.addToFavorites(currentQuote)
                    await updateFavoriteStatus(true)
                }
                
                // Erfolgsmeldung zurücksetzen
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


// MARK: - Mood/Domain API
extension QuoteViewModel {

    /// Lädt ein Zitat passend zu Stimmung und Lebensbereich.
    /// - Parameters:
    ///   - mood: Stimmung (optional; nil => Zufall)
    ///   - domain: Lebensbereich (optional; nil => Zufall)
    func refreshQuote(mood: Mood?, domain: LifeDomain?) {
        Task {
            await performQuoteLoad {
                let quote = self.quoteService.getQuote(mood: mood, domain: domain)
                await self.setCurrentQuote(quote)
            }
        }
    }
}
