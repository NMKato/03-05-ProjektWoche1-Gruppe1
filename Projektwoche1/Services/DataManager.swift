//
//  DataManager.swift
//  Projektwoche1
//
//  Created by Nikolas Kato on 18.08.25.
//

import Foundation
import SwiftData

// MARK: - DataManager
/// Zentrale Verwaltung für alle SwiftData-Operationen
/// Abstrahiert ModelContext-Zugriffe für ViewModels
final class DataManager: ObservableObject {
    
    // MARK: - Properties
    
    /// SwiftData ModelContext für Datenbankoperationen
    let modelContext: ModelContext
    
    // MARK: - Initializer
    
    /// Initialisiert DataManager mit ModelContext
    /// - Parameter modelContext: Der SwiftData ModelContext
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - Quote Operations
    
    /// Speichert ein Quote in SwiftData
    /// - Parameter quote: Das zu speichernde Quote
    /// - Throws: SwiftData Fehler bei Speicherproblemen
    func saveQuote(_ quote: Quote) throws {
        modelContext.insert(quote)
        try modelContext.save()
    }
    
    /// Lädt alle gespeicherten Quotes
    /// - Returns: Array aller Quote-Objekte
    /// - Throws: SwiftData Fehler bei Ladeproblemen
    func getAllSavedQuotes() throws -> [Quote] {
        let descriptor = FetchDescriptor<Quote>(
            sortBy: [SortDescriptor(\.dateCreated, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    /// Löscht ein Quote aus SwiftData
    /// - Parameter quote: Das zu löschende Quote
    /// - Throws: SwiftData Fehler bei Löschproblemen
    func deleteQuote(_ quote: Quote) throws {
        modelContext.delete(quote)
        try modelContext.save()
    }
    
    // MARK: - Favorites Operations
    
    /// Fügt ein Quote zu den Favoriten hinzu
    /// - Parameter quote: Das zu favoritisierende Quote
    /// - Throws: SwiftData Fehler oder DuplicateFavoriteError
    func addToFavorites(_ quote: Quote) throws {
        // Prüfe ob bereits favorisiert
        let existingFavorite = try getFavoriteForQuote(quote)
        if existingFavorite != nil {
            throw DataManagerError.duplicateFavorite
        }
        
        // Erstelle neuen Favoriten
        let favorite = FavoriteQuote(quote: quote)
        modelContext.insert(favorite)
        try modelContext.save()
    }
    
    /// Entfernt ein Quote aus den Favoriten
    /// - Parameter quote: Das Quote das entfavorisiert werden soll
    /// - Throws: SwiftData Fehler bei Problemen
    func removeFromFavorites(_ quote: Quote) throws {
        if let favorite = try getFavoriteForQuote(quote) {
            // Markiere Quote als nicht favorisiert
            quote.isFavorite = false
            
            // Lösche FavoriteQuote Eintrag
            modelContext.delete(favorite)
            try modelContext.save()
        }
    }
    
    /// Lädt alle favorisierten Quotes
    /// - Returns: Array aller FavoriteQuote-Objekte sortiert nach Datum
    /// - Throws: SwiftData Fehler bei Ladeproblemen
    func getFavoriteQuotes() throws -> [FavoriteQuote] {
        let descriptor = FetchDescriptor<FavoriteQuote>(
            sortBy: [SortDescriptor(\.dateFavorited, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    /// Löscht alle Favoriten
    /// - Throws: SwiftData Fehler bei Problemen
    func deleteAllFavorites() throws {
        let favorites = try getFavoriteQuotes()
        
        for favorite in favorites {
            // Markiere alle Quotes als nicht favorisiert
            favorite.quote.isFavorite = false
            modelContext.delete(favorite)
        }
        
        try modelContext.save()
    }
    
    // MARK: - Helper Methods
    
    /// Sucht nach einem FavoriteQuote für ein bestimmtes Quote
    /// - Parameter quote: Das Quote für das gesucht werden soll
    /// - Returns: FavoriteQuote falls gefunden, sonst nil
    /// - Throws: SwiftData Fehler bei Suchproblemen
    private func getFavoriteForQuote(_ quote: Quote) throws -> FavoriteQuote? {
        // Hole alle Favoriten und filtere manuell
        // Grund: SwiftData #Predicate hat Probleme mit verschachtelten Objektzugriffen
        let allFavorites = try modelContext.fetch(FetchDescriptor<FavoriteQuote>())
        return allFavorites.first { $0.quote.id == quote.id }
    }
    
    /// Prüft ob ein Quote bereits favorisiert ist
    /// - Parameter quote: Das zu prüfende Quote
    /// - Returns: true wenn favorisiert, false wenn nicht
    func isQuoteFavorited(_ quote: Quote) -> Bool {
        do {
            let favorite = try getFavoriteForQuote(quote)
            return favorite != nil
        } catch {
            // Bei Fehler return false (sicherer Fallback)
            return false
        }
    }
}

// MARK: - DataManager Errors
/// Fehlertypen für DataManager-Operationen
enum DataManagerError: LocalizedError {
    case duplicateFavorite
    case favoriteNotFound
    case saveFailed(Error)
    case loadFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .duplicateFavorite:
            return "Dieses Zitat ist bereits in den Favoriten."
        case .favoriteNotFound:
            return "Favorit konnte nicht gefunden werden."
        case .saveFailed(let error):
            return "Speichern fehlgeschlagen: \(error.localizedDescription)"
        case .loadFailed(let error):
            return "Laden fehlgeschlagen: \(error.localizedDescription)"
        }
    }
}
