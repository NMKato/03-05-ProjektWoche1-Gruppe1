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
            ),
            
            // Motivation
            QuoteData(text: "Jeder kleine Schritt zählt mehr als der perfekte Plan.", author: "MUSE", category: .motivation),
            QuoteData(text: "Fang an, bevor du bereit bist; Lernen kommt im Gehen.", author: "MUSE", category: .motivation),
            QuoteData(text: "Konstanz schlägt Intensität auf lange Sicht.", author: "MUSE", category: .motivation),
            QuoteData(text: "Deine Zukunft entsteht aus deinen Gewohnheiten heute.", author: "MUSE", category: .motivation),
            QuoteData(text: "Erfolge sind Zinsen auf investierte Geduld.", author: "MUSE", category: .motivation),
            QuoteData(text: "Mut ist eine Entscheidung pro Tag.", author: "MUSE", category: .motivation),
            QuoteData(text: "Disziplin ist Selbstliebe in Handlung.", author: "MUSE", category: .motivation),
            QuoteData(text: "Scheitern ist Feedback, kein Urteil.", author: "MUSE", category: .motivation),
            QuoteData(text: "Du brauchst keinen perfekten Morgen, nur den ersten Schritt.", author: "MUSE", category: .motivation),
            QuoteData(text: "Beweg dich – der Rest ordnet sich im Lauf.", author: "MUSE", category: .motivation),
            QuoteData(text: "Klarheit kommt beim Tun, nicht beim Grübeln.", author: "MUSE", category: .motivation),
            QuoteData(text: "Setz den Fokus, nicht das Feuer.", author: "MUSE", category: .motivation),
            QuoteData(text: "Routine baut Brücken über Motivationstiefs.", author: "MUSE", category: .motivation),
            QuoteData(text: "Heute säen, morgen ernten – jeden Tag ein bisschen.", author: "MUSE", category: .motivation),
            QuoteData(text: "Dein Tempo zählt, nicht der Vergleich.", author: "MUSE", category: .motivation),

            // Mindset
            QuoteData(text: "Fragen öffnen Türen, Urteile schließen sie.", author: "MUSE", category: .mindset),
            QuoteData(text: "Wer zuhört, lernt doppelt.", author: "MUSE", category: .mindset),
            QuoteData(text: "Geduld ist Tempo mit Vertrauen.", author: "MUSE", category: .mindset),
            QuoteData(text: "Grenzen sind oft alter Code im Kopf.", author: "MUSE", category: .mindset),
            QuoteData(text: "Dankbarkeit macht den Tag größer.", author: "MUSE", category: .mindset),
            QuoteData(text: "Wähle, wofür du deine Aufmerksamkeit bezahlst.", author: "MUSE", category: .mindset),
            QuoteData(text: "Flexibilität ist Intelligenz in Bewegung.", author: "MUSE", category: .mindset),
            QuoteData(text: "Ruhe ist ein Skill – trainier ihn.", author: "MUSE", category: .mindset),
            QuoteData(text: "Du bist nicht deine Gedanken, du bist ihr Autor.", author: "MUSE", category: .mindset),
            QuoteData(text: "Worte formen Wirklichkeit – wähle bewusst.", author: "MUSE", category: .mindset),

            // Weisheit
            QuoteData(text: "Zeit erklärt, was Eile verschweigt.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Ein guter Kompass ersetzt viele Karten.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Ein klares Warum macht Wege leichter.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Stille sagt oft mehr als Argumente.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Perspektive ist die leise Hälfte der Wahrheit.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Das Maß der Dinge ist der Mensch, nicht das Echo.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Freundlichkeit verkürzt jede Distanz.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Erkenntnis beginnt, wo Gewissheit endet.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Wer teilt, vermehrt.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Weise ist, wer neu denken kann.", author: "MUSE", category: .wisdom),

            // Programmierung
            QuoteData(text: "Erst testen, dann bauen.", author: "MUSE", category: .programming),
            QuoteData(text: "Sauberer Code erklärt sich leise.", author: "MUSE", category: .programming),
            QuoteData(text: "Automatisiere, was dich langweilt.", author: "MUSE", category: .programming),
            QuoteData(text: "Kleine Commits, klare Gedanken.", author: "MUSE", category: .programming),
            QuoteData(text: "Komplexität schuldet Zinsen.", author: "MUSE", category: .programming),
            QuoteData(text: "Lesbarkeit ist ein Feature.", author: "MUSE", category: .programming),
            QuoteData(text: "Benenne Dinge, bis sie klar sind.", author: "MUSE", category: .programming),
            QuoteData(text: "Refactor ist Pflege, nicht Luxus.", author: "MUSE", category: .programming),
            QuoteData(text: "Daten zuerst, Meinung später.", author: "MUSE", category: .programming),
            QuoteData(text: "Ist es schwer zu testen, ist es zu eng gekoppelt.", author: "MUSE", category: .programming),

            // General
            QuoteData(text: "Heute ist der beste Tag, freundlich zu sein.", author: "MUSE", category: .general),
            QuoteData(text: "Licht findet den, der es trägt.", author: "MUSE", category: .general),
            QuoteData(text: "Weniger Rauschen, mehr Nähe.", author: "MUSE", category: .general),
            QuoteData(text: "Ordnung im Außen schafft Raum im Innen.", author: "MUSE", category: .general),
            QuoteData(text: "Teile, was du suchst: Zeit, Mut, Ideen.", author: "MUSE", category: .general),

            // Motivation (zusätzlich)
            QuoteData(text: "Beginne da, wo deine Füße stehen.", author: "MUSE", category: .motivation),
            QuoteData(text: "Mach’s einfach – und dann mach es einfach.", author: "MUSE", category: .motivation),
            QuoteData(text: "Ausdauer macht den Unterschied sichtbar.", author: "MUSE", category: .motivation),
            QuoteData(text: "Ziele justierst du im Laufen.", author: "MUSE", category: .motivation),
            QuoteData(text: "Dein Kalender zeigt, was dir wichtig ist.", author: "MUSE", category: .motivation),

            // Mindset (zusätzlich)
            QuoteData(text: "Akzeptanz ist der schnellste Weg nach vorn.", author: "MUSE", category: .mindset),
            QuoteData(text: "Neugier ist Mut ohne Rüstung.", author: "MUSE", category: .mindset),
            QuoteData(text: "Loslassen schafft Platz für Qualität.", author: "MUSE", category: .mindset),
            QuoteData(text: "Vergleiche rauben Fokus – zähle Fortschritt.", author: "MUSE", category: .mindset),
            QuoteData(text: "Bewusste Pausen sind Produktivität.", author: "MUSE", category: .mindset),

            // Weisheit (zusätzlich)
            QuoteData(text: "Wähle Wege, nicht Beifall.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Hören verbindet, Recht haben trennt.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Ein gutes Nein schützt gute Jas.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Wer Fragen pflegt, erntet Einsicht.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Maß halten ist hohe Kunst.", author: "MUSE", category: .wisdom)

            
            
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


typealias Weighted<T> = (item: T, weight: Int)


// MARK: - Mood/Domain basierte Auswahl
extension QuoteService {

    /// Liefert ein Zitat passend zu Stimmung und Lebensbereich.
    /// Fällt bei Leerauswahl auf Zufall zurück.
    func getQuote(mood: Mood?, domain: LifeDomain?) -> Quote {
        guard let mood, let domain else {
            return getRandomQuote()
        }

        // 1) Gewichte bestimmen
        let weighted = weightedCategories(for: mood, domain: domain)

        // 2) Gewichtete Kategorie ziehen
        let chosenCategory = pickWeighted(weighted)

        // 3) Kandidaten aus gewählter Kategorie
        let candidates = getQuotesByCategory(chosenCategory)
        if let picked = candidates.randomElement() { return picked }

        // 4) Soft-Fallbacks: weitere Top-Kategorien
        for entry in weighted.sorted(by: { $0.weight > $1.weight }).dropFirst() {
            let more = getQuotesByCategory(entry.item)
            if let picked = more.randomElement() { return picked }
        }

        // 5) Hard-Fallback
        return getRandomQuote()
    }

    // MARK: - Gewichtsmatrix
    private func weightedCategories(for mood: Mood, domain: LifeDomain) -> [Weighted<Category>] {
        switch (mood, domain) {
        // Freude
        case (.freude, .leisure):
            return [(.general, 4), (.wisdom, 3), (.mindset, 3), (.motivation, 2), (.drinking, 1)]
        case (.freude, .work):
            return [(.motivation, 4), (.mindset, 3), (.wisdom, 2), (.general, 2), (.programming, 1)]
        case (.freude, .privateLife):
            return [(.general, 4), (.mindset, 3), (.wisdom, 2), (.motivation, 2)]

        // Traurig
        case (.traurig, .work):
            return [(.motivation, 5), (.mindset, 4), (.wisdom, 3), (.general, 1)]
        case (.traurig, .leisure):
            return [(.mindset, 4), (.wisdom, 3), (.general, 2), (.motivation, 2)]
        case (.traurig, .privateLife):
            return [(.mindset, 5), (.wisdom, 4), (.motivation, 2), (.general, 1)]

        // Unsicher
        case (.unsicher, .work):
            return [(.mindset, 5), (.motivation, 3), (.wisdom, 3), (.programming, 1)]
        case (.unsicher, .leisure):
            return [(.mindset, 4), (.wisdom, 3), (.general, 2), (.motivation, 2)]
        case (.unsicher, .privateLife):
            return [(.mindset, 5), (.wisdom, 4), (.general, 2)]

        // Enttäuscht
        case (.enttaeuscht, .work):
            return [(.motivation, 5), (.mindset, 4), (.wisdom, 3)]
        case (.enttaeuscht, .leisure):
            return [(.mindset, 4), (.wisdom, 3), (.general, 2), (.motivation, 2)]
        case (.enttaeuscht, .privateLife):
            return [(.mindset, 5), (.wisdom, 4), (.motivation, 2)]
        }
    }

    // MARK: - Utility
    private func pickWeighted<T>(_ items: [Weighted<T>]) -> T {
        let total = max(items.reduce(0) { $0 + max($1.weight, 0) }, 1)
        let r = Int.random(in: 1...total)
        var running = 0
        for entry in items {
            running += max(entry.weight, 0)
            if r <= running { return entry.item }
        }
        return items.last!.item
    }
}
