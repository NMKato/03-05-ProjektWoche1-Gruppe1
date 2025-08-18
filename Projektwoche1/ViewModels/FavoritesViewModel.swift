//
//  FavoritesViewModel.swift
//  Projektwoche1
//
//  Created by Nikolas Kato on 18.08.25.
//

import Foundation
import SwiftUI

// MARK: - FavoritesViewModel
/// ViewModel für die Favoriten-Ansicht der QuoteCraft App
/// Verwaltet Liste der favorisierten Zitate und deren Operationen
@MainActor
final class FavoritesViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Liste aller favorisierten Zitate
    @Published var favoriteQuotes: [FavoriteQuote] = []
    
    /// Loading-Status für UI-Feedback
    @Published var isLoading: Bool = false
    
    /// Fehlermeldung für Benutzer-Feedback
    @Published var errorMessage: String?
    
    /// Anzahl der Favoriten für UI-Display
    @Published var favoritesCount: Int = 0
    
    // MARK: - Private Properties
    
    /// DataManager für SwiftData-Operationen
    private let dataManager: DataManager
    
    // MARK: - Initializer
    
    /// Initialisiert das ViewModel mit DataManager
    /// - Parameter dataManager: DataManager für Datenpersistierung
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    // MARK: - Public Methods
    
    /// Lädt alle favorisierten Zitate aus der Datenbank
    /// Wird von FavoritesView beim onAppear aufgerufen
    func loadFavorites() {
        Task {
            await performDataOperation {
                let favorites = try self.dataManager.getFavoriteQuotes()
                await self.updateFavoritesList(favorites)
            }
        }
    }
    
    /// Entfernt ein spezifisches Zitat aus den Favoriten
    /// - Parameter favoriteQuote: Das zu entfernende FavoriteQuote
    func removeFavorite(_ favoriteQuote: FavoriteQuote) {
        Task {
            await performDataOperation {
                try self.dataManager.removeFromFavorites(favoriteQuote.quote)
                await self.removeFromLocalList(favoriteQuote)
            }
        }
    }
    
    /// Entfernt mehrere Favoriten auf einmal (für Delete-Swipe)
    /// - Parameter favoriteQuotes: Array der zu entfernenden FavoriteQuotes
    func removeFavorites(_ favoriteQuotes: [FavoriteQuote]) {
        Task {
            await performDataOperation {
                for favoriteQuote in favoriteQuotes {
                    try self.dataManager.removeFromFavorites(favoriteQuote.quote)
                }
                await self.removeMultipleFromLocalList(favoriteQuotes)
            }
        }
    }
    
    /// Löscht alle Favoriten (Danger-Zone Funktion)
    /// Zeigt Confirmation-Dialog vor Ausführung
    func clearAllFavorites() {
        Task {
            await performDataOperation {
                try self.dataManager.deleteAllFavorites()
                await self.clearLocalList()
            }
        }
    }
    
    /// Aktualisiert die Favoriten-Liste (nach Änderungen in anderen Views)
    /// Wird aufgerufen wenn von QuoteView aus favorisiert/entfavorisiert wird
    func refreshFavorites() {
        loadFavorites()
    }
    
    /// Prüft ob die Favoriten-Liste leer ist
    /// - Returns: true wenn keine Favoriten vorhanden
    var isEmpty: Bool {
        favoriteQuotes.isEmpty
    }
    
    /// Löscht die aktuelle Fehlermeldung
    /// Wird von UI-Elementen aufgerufen um Fehler zu dismissen
    func clearError() async {
        await MainActor.run {
            errorMessage = nil
        }
    }
    
    /// Gibt ein zufälliges Favorit zurück (für Random-Feature)
    /// - Returns: Zufälliges FavoriteQuote oder nil wenn Liste leer
    func getRandomFavorite() -> FavoriteQuote? {
        return favoriteQuotes.randomElement()
    }
}

// MARK: - Private Helper Methods
private extension FavoritesViewModel {
    
    /// Führt eine Datenoperation mit Loading-Status und Error-Handling aus
    /// - Parameter operation: Die auszuführende async Operation
    func performDataOperation(_ operation: @escaping () async throws -> Void) async {
        await setLoading(true)
        await clearError()
        
        do {
            try await operation()
        } catch {
            await handleError(error)
        }
        
        await setLoading(false)
    }
    
    /// Aktualisiert die lokale Favoriten-Liste
    /// - Parameter favorites: Neue Liste der FavoriteQuotes
    func updateFavoritesList(_ favorites: [FavoriteQuote]) async {
        await MainActor.run {
            self.favoriteQuotes = favorites
            self.favoritesCount = favorites.count
        }
    }
    
    /// Entfernt ein FavoriteQuote aus der lokalen Liste
    /// - Parameter favoriteQuote: Das zu entfernende FavoriteQuote
    func removeFromLocalList(_ favoriteQuote: FavoriteQuote) async {
        await MainActor.run {
            self.favoriteQuotes.removeAll { $0.id == favoriteQuote.id }
            self.favoritesCount = self.favoriteQuotes.count
        }
    }
    
    /// Entfernt mehrere FavoriteQuotes aus der lokalen Liste
    /// - Parameter favoriteQuotes: Array der zu entfernenden FavoriteQuotes
    func removeMultipleFromLocalList(_ favoriteQuotes: [FavoriteQuote]) async {
        await MainActor.run {
            let idsToRemove = Set(favoriteQuotes.map { $0.id })
            self.favoriteQuotes.removeAll { idsToRemove.contains($0.id) }
            self.favoritesCount = self.favoriteQuotes.count
        }
    }
    
    /// Leert die lokale Favoriten-Liste
    func clearLocalList() async {
        await MainActor.run {
            self.favoriteQuotes.removeAll()
            self.favoritesCount = 0
        }
    }
    
    /// Aktualisiert den Loading-Status
    /// - Parameter loading: Neuer Loading-Status
    func setLoading(_ loading: Bool) async {
        await MainActor.run {
            isLoading = loading
        }
    }
    
    /// Behandelt Fehler und zeigt benutzerfreundliche Nachricht
    /// - Parameter error: Der aufgetretene Fehler
    func handleError(_ error: Error) async {
        await MainActor.run {
            if let dataError = error as? DataManagerError {
                errorMessage = dataError.errorDescription
            } else {
                errorMessage = "Fehler beim Verwalten der Favoriten: \(error.localizedDescription)"
            }
        }
    }
}

// MARK: - Computed Properties for UI
extension FavoritesViewModel {
    
    /// Formatierte Anzeige der Favoriten-Anzahl
    var favoritesCountText: String {
        switch favoritesCount {
        case 0:
            return "Keine Favoriten"
        case 1:
            return "1 Favorit"
        default:
            return "\(favoritesCount) Favoriten"
        }
    }
    
    /// Gruppiert Favoriten nach Kategorie für erweiterte UI
    /// - Returns: Dictionary mit Category als Key und FavoriteQuotes als Value
    var favoritesByCategory: [Category: [FavoriteQuote]] {
        Dictionary(grouping: favoriteQuotes) { favoriteQuote in
            favoriteQuote.quote.category ?? .general
        }
    }
    
    /// Gibt die neuesten 3 Favoriten zurück (für Preview-Widget)
    var recentFavorites: [FavoriteQuote] {
        Array(favoriteQuotes.prefix(3))
    }
}
