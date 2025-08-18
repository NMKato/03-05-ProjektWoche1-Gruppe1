//
//  Quote.swift
//  Projektwoche1
//
//  Created by Nikolas Kato on 18.08.25.
//

import Foundation
import SwiftData

// MARK: - Quote Model
/// Repräsentiert ein einzelnes Zitat in der App
/// SwiftData Model für persistente Speicherung
@Model
final class Quote {
    
    // MARK: - Properties
    
    /// Eindeutige Identifikation des Zitats
    @Attribute(.unique) var id: UUID
    
    /// Der Zitat-Text selbst
    var text: String
    
    /// Name der Autorin/des Autors
    var author: String
    
    /// Optionale Kategorie (z.B. .motivation, .wisdom)
    var category: Category?
    
    /// Erstellungsdatum des Zitats
    var dateCreated: Date
    
    /// Markierung ob Zitat favorisiert ist
    var isFavorite: Bool
    
    // MARK: - Initializer
    
    /// Erstellt ein neues Zitat
    /// - Parameters:
    ///   - text: Der Zitat-Text
    ///   - author: Name der Autorin/des Autors
    ///   - category: Optionale Kategorie (Category Enum)
    init(text: String, author: String, category: Category? = nil) {
        self.id = UUID()
        self.text = text
        self.author = author
        self.category = category
        self.dateCreated = Date()
        self.isFavorite = false
    }
}

// MARK: - FavoriteQuote Model
/// Repräsentiert ein favorisiertes Zitat
/// Separate Entität für bessere Favoriten-Verwaltung
@Model
final class FavoriteQuote {
    
    // MARK: - Properties
    
    /// Eindeutige Identifikation des Favoriten-Eintrags
    @Attribute(.unique) var id: UUID
    
    /// Referenz zum originalen Zitat
    var quote: Quote
    
    /// Zeitpunkt wann das Zitat favorisiert wurde
    var dateFavorited: Date
    
    // MARK: - Initializer
    
    /// Erstellt einen neuen Favoriten-Eintrag
    /// - Parameter quote: Das zu favoritisierende Zitat
    init(quote: Quote) {
        self.id = UUID()
        self.quote = quote
        self.dateFavorited = Date()
        
        // Markiere das originale Zitat als favorisiert
        quote.isFavorite = true
    }
}
