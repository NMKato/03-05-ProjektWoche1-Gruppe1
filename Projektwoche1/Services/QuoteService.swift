//
//  QuoteService.swift
//  Projektwoche1
//
//  Created by Nikolas Kato on 18.08.25.
//

import Foundation

// MARK: - QuoteService
/// Service-Klasse für Zitate-Verwaltung
/// Stellt lokale Zitate zur Verfügung und abstrahiert Datenquelle
final class QuoteService {
    
    // MARK: - Properties
    
    /// Alle verfügbaren Zitate in der App
    private let quotes: [QuoteData]
    
    // MARK: - Initializer
    
    /// Initialisiert den Service mit vorgefertigten Zitaten
    init() {
        self.quotes = QuoteService.createDefaultQuotes()
    }
    
    // MARK: - Public Methods
    
    /// Gibt ein zufälliges Zitat zurück
    /// - Returns: Zufällig ausgewähltes Quote-Objekt
    func getRandomQuote() -> Quote {
        let randomQuoteData = quotes.randomElement() ?? QuoteService.fallbackQuote
        return Quote(
            text: randomQuoteData.text,
            author: randomQuoteData.author,
            category: randomQuoteData.category
        )
    }
    
    /// Gibt alle verfügbaren Zitate zurück
    /// - Returns: Array aller Quote-Objekte
    func getAllQuotes() -> [Quote] {
        return quotes.map { quoteData in
            Quote(
                text: quoteData.text,
                author: quoteData.author,
                category: quoteData.category
            )
        }
    }
    
    /// Gibt Zitate einer bestimmten Kategorie zurück
    /// - Parameter category: Die gewünschte Kategorie (Category Enum)
    /// - Returns: Array der Quote-Objekte aus der Kategorie
    func getQuotesByCategory(_ category: Category) -> [Quote] {
        let filteredQuotes = quotes.filter { $0.category == category }
        return filteredQuotes.map { quoteData in
            Quote(
                text: quoteData.text,
                author: quoteData.author,
                category: quoteData.category
            )
        }
    }
    
    /// Gibt alle verfügbaren Kategorien zurück
    /// - Returns: Array aller eindeutigen Kategorien
    func getAvailableCategories() -> [Category] {
        let categories = quotes.compactMap { $0.category }
        return Array(Set(categories)).sorted { $0.rawValue < $1.rawValue }
    }
}

// MARK: - QuoteData Helper Struct
/// Hilfsstruct für Rohdaten der Zitate
/// Wird nur intern im Service verwendet
private struct QuoteData {
    let text: String
    let author: String
    let category: Category?
}

// MARK: - Default Quotes
private extension QuoteService {
    
    /// Erstellt die Standard-Zitate für die App
    /// - Returns: Array von QuoteData mit vorgefertigten Zitaten
    static func createDefaultQuotes() -> [QuoteData] {
        return [
            // Motivation
            QuoteData(
                text: "Der beste Weg, die Zukunft vorherzusagen, ist, sie zu erschaffen.",
                author: "Peter Drucker",
                category: .motivation
            ),
            QuoteData(
                text: "Was immer du tun kannst oder träumst zu können, fang damit an.",
                author: "Johann Wolfgang von Goethe",
                category: .motivation
            ),
            QuoteData(
                text: "Erfolg ist nicht endgültig, Misserfolg ist nicht fatal: Es ist der Mut weiterzumachen, der zählt.",
                author: "Winston Churchill",
                category: .motivation
            ),
            
            // Weisheit
            QuoteData(
                text: "Ich weiß, dass ich nichts weiß.",
                author: "Sokrates",
                category: .wisdom
            ),
            QuoteData(
                text: "Die einzige Konstante im Leben ist die Veränderung.",
                author: "Heraklit",
                category: .wisdom
            ),
            QuoteData(
                text: "Zeit, die wir uns nehmen, ist Zeit, die uns etwas gibt.",
                author: "Ernst Ferstl",
                category: .wisdom
            ),
            
            // Programmierung
            QuoteData(
                text: "Einfachheit ist die höchste Stufe der Vollendung.",
                author: "Leonardo da Vinci",
                category: .programming
            ),
            QuoteData(
                text: "Zuerst löse das Problem. Dann schreibe den Code.",
                author: "John Johnson",
                category: .programming
            ),
            
            // Allgemein (keine Kategorie)
            QuoteData(
                text: "Das Leben ist das, was passiert, während du eifrig dabei bist, andere Pläne zu machen.",
                author: "John Lennon",
                category: nil
            ),
            QuoteData(
                text: "Sei du selbst die Veränderung, die du dir wünschst für diese Welt.",
                author: "Mahatma Gandhi",
                category: nil
            )
        ]
    }
    
    /// Fallback-Zitat falls keine Zitate verfügbar sind
    static var fallbackQuote: QuoteData {
        return QuoteData(
            text: "Großartige Dinge entstehen durch kleine Anfänge.",
            author: "QuoteCraft",
            category: nil
        )
    }
}
