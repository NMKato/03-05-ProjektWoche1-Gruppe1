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
            QuoteData(text: "Maß halten ist hohe Kunst.", author: "MUSE", category: .wisdom),
            
            
            // MARK: - Motivation (50)
            QuoteData(text: "Beginne klein, bleib dran, wachse groß.", author: "MUSE", category: .motivation),
            QuoteData(text: "Handlung schlägt Ausreden in jeder Runde.", author: "MUSE", category: .motivation),
            QuoteData(text: "Dein Ziel braucht heute einen Termin im Kalender.", author: "MUSE", category: .motivation),
            QuoteData(text: "Wer anfängt, hat schon das Schwerste erledigt.", author: "MUSE", category: .motivation),
            QuoteData(text: "Schweiß ist die Tinte deiner Fortschritte.", author: "MUSE", category: .motivation),
            QuoteData(text: "Aufgeben ist nur eine Meinung, kein Fakt.", author: "MUSE", category: .motivation),
            QuoteData(text: "Setz Prioritäten, nicht Panik.", author: "MUSE", category: .motivation),
            QuoteData(text: "Dein zukünftiges Ich dankt dir für heute.", author: "MUSE", category: .motivation),
            QuoteData(text: "Tempo ist optional, Richtung ist Pflicht.", author: "MUSE", category: .motivation),
            QuoteData(text: "Erwartungen senken, Einsatz erhöhen.", author: "MUSE", category: .motivation),
            QuoteData(text: "Du musst nicht perfekt sein, nur verfügbar.", author: "MUSE", category: .motivation),
            QuoteData(text: "Ziele ohne Systeme sind Wünsche mit Deadline.", author: "MUSE", category: .motivation),
            QuoteData(text: "Mach’s jetzt, bevor der Mut verschwindet.", author: "MUSE", category: .motivation),
            QuoteData(text: "Konsequenz macht Träume alltagstauglich.", author: "MUSE", category: .motivation),
            QuoteData(text: "Die ersten Minuten entscheiden den Tag.", author: "MUSE", category: .motivation),
            QuoteData(text: "Weniger scrollen, mehr handeln.", author: "MUSE", category: .motivation),
            QuoteData(text: "Fehler zählen als Trainingseinheiten.", author: "MUSE", category: .motivation),
            QuoteData(text: "Die Hürde ist hoch – spring trotzdem.", author: "MUSE", category: .motivation),
            QuoteData(text: "Arbeite leise, liefere laut.", author: "MUSE", category: .motivation),
            QuoteData(text: "Deine Disziplin ist dein Wettbewerbsvorteil.", author: "MUSE", category: .motivation),
            QuoteData(text: "Routine ist Motivation auf Autopilot.", author: "MUSE", category: .motivation),
            QuoteData(text: "Setz den Fokus dorthin, wo du Einfluss hast.", author: "MUSE", category: .motivation),
            QuoteData(text: "Heute zählt doppelt, wenn du anfängst.", author: "MUSE", category: .motivation),
            QuoteData(text: "Nimm die Abkürzung: Tu es einfach.", author: "MUSE", category: .motivation),
            QuoteData(text: "Schaffe dir Reibungslosigkeit, nicht Reibung.", author: "MUSE", category: .motivation),
            QuoteData(text: "Du wirst nie bereit sein – fang trotzdem an.", author: "MUSE", category: .motivation),
            QuoteData(text: "Haltung vor Haltungnahme: Steh früher auf.", author: "MUSE", category: .motivation),
            QuoteData(text: "Ein klarer Plan rettet schwache Laune.", author: "MUSE", category: .motivation),
            QuoteData(text: "Mach es sichtbar: Tracke deinen Fortschritt.", author: "MUSE", category: .motivation),
            QuoteData(text: "Grenzen verschieben sich beim Gehen.", author: "MUSE", category: .motivation),
            QuoteData(text: "Du trainierst, auch wenn du scheiterst.", author: "MUSE", category: .motivation),
            QuoteData(text: "Mut ist ein Muskel. Benutz ihn täglich.", author: "MUSE", category: .motivation),
            QuoteData(text: "Ersetze Zweifel durch Daten aus Erfahrung.", author: "MUSE", category: .motivation),
            QuoteData(text: "Jedes Ja braucht ein bewusstes Nein.", author: "MUSE", category: .motivation),
            QuoteData(text: "Kleine Siege machen dich unaufhaltsam.", author: "MUSE", category: .motivation),
            QuoteData(text: "Fertig ist besser als abgebrochen perfekt.", author: "MUSE", category: .motivation),
            QuoteData(text: "Erfolg beginnt, wenn du aufhörst zu warten.", author: "MUSE", category: .motivation),
            QuoteData(text: "Disziplin ist Freiheit auf Raten.", author: "MUSE", category: .motivation),
            QuoteData(text: "Weniger denken, mehr durchziehen.", author: "MUSE", category: .motivation),
            QuoteData(text: "Dein Standard bestimmt dein Ergebnis.", author: "MUSE", category: .motivation),
            QuoteData(text: "Heute säen, morgen staunen.", author: "MUSE", category: .motivation),
            QuoteData(text: "Der Unterschied? Dranbleiben, wenn’s langweilig wird.", author: "MUSE", category: .motivation),
            QuoteData(text: "Fokussiere das Nötige, nicht das Neue.", author: "MUSE", category: .motivation),
            QuoteData(text: "Du bist näher dran als gestern.", author: "MUSE", category: .motivation),
            QuoteData(text: "Mach den Plan so simpel, dass er passiert.", author: "MUSE", category: .motivation),
            QuoteData(text: "Hindernisse sind Rohmaterial für Stärke.", author: "MUSE", category: .motivation),
            QuoteData(text: "Setz den ersten Timer und leg los.", author: "MUSE", category: .motivation),
            QuoteData(text: "Die beste Motivation ist ein klarer nächster Schritt.", author: "MUSE", category: .motivation),
            QuoteData(text: "Arbeite an dir wie an einem Produkt.", author: "MUSE", category: .motivation),
            QuoteData(text: "Mach Fortschritt sichtbar – dann macht er weiter.", author: "MUSE", category: .motivation),
            QuoteData(text: "Wer beginnt, gewinnt Momentum.", author: "MUSE", category: .motivation),

            // MARK: - Weisheit (50)
            QuoteData(text: "Wer langsam schaut, sieht weiter.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Wert entsteht dort, wo Aufmerksamkeit verweilt.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Hinter jedem Entweder steckt ein Sowohl.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Gedanken sind Gäste – entscheide, wer bleibt.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Fülle beginnt mit Genügsamkeit.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Ein guter Rat kommt leise.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Wahrheit ist selten bequem, oft hilfreich.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Respekt ist die Währung stabiler Beziehungen.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Verstehen heißt, die Perspektive wechseln zu können.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Sinn entsteht dort, wo Verantwortung beginnt.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Ein ruhiger Kopf hört mehr.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Wissen erklärt, Weisheit entscheidet.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Das Bessere ist Feind des Genug.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Wer dankt, vergleicht seltener.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Zuhören spart Umwege.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Die richtige Frage wiegt mehr als zehn Antworten.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Geduld ist die Kunst, Zeit arbeiten zu lassen.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Eile ist ein schlechter Ratgeber, ein guter Alarm.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Wer seinen Schatten kennt, tritt sicherer auf.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Freiheit wächst aus Grenzen, die wir wählen.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Nicht jedes Echo ist Applaus.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Klarheit beginnt mit Ehrlichkeit zu sich selbst.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Ein gutes Nein schützt ein besseres Ja.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Stille ist nicht leer – sie ist voll Optionen.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Wer teilt, verliert nichts – er vermehrt.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Charakter ist Verhalten ohne Publikum.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Güte ist Stärke ohne Lärm.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Manche Türen öffnen sich, wenn man klopft – andere, wenn man wartet.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Balance ist Bewegung, nicht Zustand.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Komplexe Probleme lieben einfache Fragen.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Wer Menschen versteht, gewinnt Diskussionen gar nicht erst.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Demut ist Intelligenz ohne Arroganz.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Tradition ist Erfahrung, kein Argument.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Vertrauen wächst in der Zeit, bricht in einem Moment.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Hoffnung ist mutige Vernunft.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Nicht alles Wichtige ist dringend – und umgekehrt.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Wähle Wege, nicht Beifall.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Wer Fragen pflegt, erntet Einsicht.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Weitsicht entsteht aus Nähe und Distanz zugleich.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Versöhnung heilt, was Recht nicht kann.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Menschen vor Meinungen – immer.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Wähle Worte, die du wiederfinden willst.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Gerechtigkeit beginnt im Alltagston.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Wer Ruhe findet, verliert weniger Nerven.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Wertvolle Ziele brauchen lange Atemzüge.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Sicher ist selten sinnvoll, sinnvoll oft sicher.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Vernetzung ersetzt nicht Verbindlichkeit.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Verstehen ist die langsamste Abkürzung.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Zufriedenheit ist leise, aber mächtig.", author: "MUSE", category: .wisdom),
            QuoteData(text: "Wer loslässt, greift besser.", author: "MUSE", category: .wisdom),

            // MARK: - Programmierung (50)
            QuoteData(text: "Baue Schnittstellen, nicht Abhängigkeiten.", author: "MUSE", category: .programming),
            QuoteData(text: "Kapsle Komplexität – nicht Verantwortung.", author: "MUSE", category: .programming),
            QuoteData(text: "Lesbarer Code spart die meiste Zeit.", author: "MUSE", category: .programming),
            QuoteData(text: "Teste Verhalten, nicht Implementierung.", author: "MUSE", category: .programming),
            QuoteData(text: "Wenn es schwer zu benennen ist, ist es zu groß.", author: "MUSE", category: .programming),
            QuoteData(text: "Refactor früh, sonst refactorst du ständig.", author: "MUSE", category: .programming),
            QuoteData(text: "Nur was du misst, kannst du verbessern.", author: "MUSE", category: .programming),
            QuoteData(text: "Fehlerbotschaften sind Teil der UX.", author: "MUSE", category: .programming),
            QuoteData(text: "Architektur ist Teamkommunikation in Code.", author: "MUSE", category: .programming),
            QuoteData(text: "Dokumentiere das Warum, nicht das Offensichtliche.", author: "MUSE", category: .programming),
            QuoteData(text: "Feature-Flags retten Releases.", author: "MUSE", category: .programming),
            QuoteData(text: "Automatisiere Builds, automatisiere Vertrauen.", author: "MUSE", category: .programming),
            QuoteData(text: "Ein PR pro Thema, ein Gedanke pro Commit.", author: "MUSE", category: .programming),
            QuoteData(text: "Null ist ein Wert, behandle ihn so.", author: "MUSE", category: .programming),
            QuoteData(text: "Concurrency benötigt Klarheit, nicht Mut.", author: "MUSE", category: .programming),
            QuoteData(text: "Caching löst Probleme – und schafft neue.", author: "MUSE", category: .programming),
            QuoteData(text: "Datenmodelle sind Verträge mit der Zukunft.", author: "MUSE", category: .programming),
            QuoteData(text: "Schreibe erst den Test, dann den Fix.", author: "MUSE", category: .programming),
            QuoteData(text: "Magic Numbers sind Schulden mit Zinsen.", author: "MUSE", category: .programming),
            QuoteData(text: "Logging ohne Kontext ist Lärm.", author: "MUSE", category: .programming),
            QuoteData(text: "Handle Fehler explizit, nicht heroisch.", author: "MUSE", category: .programming),
            QuoteData(text: "Überlege Grenzen, bevor du Felder hinzufügst.", author: "MUSE", category: .programming),
            QuoteData(text: "API-Design ist Produktdesign.", author: "MUSE", category: .programming),
            QuoteData(text: "Ein gutes Enum spart eine Klasse.", author: "MUSE", category: .programming),
            QuoteData(text: "Vermeide globalen Zustand; er merkt sich Fehler.", author: "MUSE", category: .programming),
            QuoteData(text: "Komposition vor Vererbung – fast immer.", author: "MUSE", category: .programming),
            QuoteData(text: "Ladezeiten sind Features ohne Marketing.", author: "MUSE", category: .programming),
            QuoteData(text: "Security ist ein Prozess, kein Patch.", author: "MUSE", category: .programming),
            QuoteData(text: "Monolith oder Microservices? Teamreife entscheidet.", author: "MUSE", category: .programming),
            QuoteData(text: "Klare Grenzen, klare Zuständigkeiten.", author: "MUSE", category: .programming),
            QuoteData(text: "Don’t mock what you don’t own – kontrolliere Schnittstellen.", author: "MUSE", category: .programming),
            QuoteData(text: "Konfigurierbarkeit ist kein Ersatz für Entscheidungen.", author: "MUSE", category: .programming),
            QuoteData(text: "Lerne die Tools, die dich verlangsamen.", author: "MUSE", category: .programming),
            QuoteData(text: "Performance ist UX in Millisekunden.", author: "MUSE", category: .programming),
            QuoteData(text: "Leserlichkeit > Cleverness.", author: "MUSE", category: .programming),
            QuoteData(text: "Ein Diagramm spart hundert Nachrichten.", author: "MUSE", category: .programming),
            QuoteData(text: "Domain-Sprache in den Code, nicht daneben.", author: "MUSE", category: .programming),
            QuoteData(text: "Feature-Freeze ist Fokus mit Deadline.", author: "MUSE", category: .programming),
            QuoteData(text: "Schütze dich vor deinem zukünftigen Ich: prüfe Eingaben.", author: "MUSE", category: .programming),
            QuoteData(text: "Wenn es schwer zu testen ist, entkopple es.", author: "MUSE", category: .programming),
            QuoteData(text: "Später ist teurer als jetzt.", author: "MUSE", category: .programming),
            QuoteData(text: "Defaults sind Designentscheidungen.", author: "MUSE", category: .programming),
            QuoteData(text: "Die beste Abstraktion ist die, die du erklären kannst.", author: "MUSE", category: .programming),
            QuoteData(text: "Lass Code alt werden, nicht unbeobachtet.", author: "MUSE", category: .programming),
            QuoteData(text: "Metriken ohne Ziele sind Zahlen ohne Richtung.", author: "MUSE", category: .programming),
            QuoteData(text: "Werkzeuge ändern nichts ohne Gewohnheiten.", author: "MUSE", category: .programming),
            QuoteData(text: "Guter Code scheitert elegant.", author: "MUSE", category: .programming),
            QuoteData(text: "Einfachheit ist ein teures Designziel.", author: "MUSE", category: .programming),
            QuoteData(text: "Baue für Klarheit, optimiere für Last.", author: "MUSE", category: .programming),
            QuoteData(text: "Technische Schulden sind Management-Aufgaben.", author: "MUSE", category: .programming),
            QuoteData(text: "Versioniere Verträge, nicht nur Code.", author: "MUSE", category: .programming),

            // MARK: - Allgemein (50)
            QuoteData(text: "Ein guter Morgen beginnt am Abend davor.", author: "MUSE", category: .general),
            QuoteData(text: "Wertvolle Gespräche brauchen Pausen.", author: "MUSE", category: .general),
            QuoteData(text: "Ein freundlicher Blick wiegt mehr als viele Worte.", author: "MUSE", category: .general),
            QuoteData(text: "Ordnung spart Energie, Chaos kostet sie.", author: "MUSE", category: .general),
            QuoteData(text: "Halte fest, was dich leicht macht.", author: "MUSE", category: .general),
            QuoteData(text: "Weniger Termindruck, mehr Zeitgefühl.", author: "MUSE", category: .general),
            QuoteData(text: "Zu Hause ist da, wo du tief atmest.", author: "MUSE", category: .general),
            QuoteData(text: "Schöne Tage wachsen aus kleinen Ritualen.", author: "MUSE", category: .general),
            QuoteData(text: "Sag öfter danke, als du musst.", author: "MUSE", category: .general),
            QuoteData(text: "Ein Spaziergang klärt mehr als ein Streit.", author: "MUSE", category: .general),
            QuoteData(text: "Ein Lächeln ist der kürzeste Weg zu Menschen.", author: "MUSE", category: .general),
            QuoteData(text: "Erinnerungen sind die Zinsen gelebter Zeit.", author: "MUSE", category: .general),
            QuoteData(text: "Wer teilt, verdoppelt seine Freude.", author: "MUSE", category: .general),
            QuoteData(text: "Kleine Aufmerksamkeiten bauen große Brücken.", author: "MUSE", category: .general),
            QuoteData(text: "Die beste Antwort ist oft ein offenes Ohr.", author: "MUSE", category: .general),
            QuoteData(text: "Gelassenheit schmeckt nach Freiheit.", author: "MUSE", category: .general),
            QuoteData(text: "Plane Pausen wie Termine.", author: "MUSE", category: .general),
            QuoteData(text: "Ein sauberer Schreibtisch ist ein guter Start.", author: "MUSE", category: .general),
            QuoteData(text: "Wer fragt, zeigt Wertschätzung.", author: "MUSE", category: .general),
            QuoteData(text: "Freundlichkeit ist selten zu viel.", author: "MUSE", category: .general),
            QuoteData(text: "Langsam essen ist ein Kompliment an den Tag.", author: "MUSE", category: .general),
            QuoteData(text: "Licht macht Laune – öffne die Vorhänge.", author: "MUSE", category: .general),
            QuoteData(text: "Zu spät ist besser als nie – und pünktlich besser als beides.", author: "MUSE", category: .general),
            QuoteData(text: "Gute Fragen machen Treffen kürzer.", author: "MUSE", category: .general),
            QuoteData(text: "Ein Handschlag kann ein Vertrag sein.", author: "MUSE", category: .general),
            QuoteData(text: "Ehrliche Komplimente sind Tagesvitamine.", author: "MUSE", category: .general),
            QuoteData(text: "Weniger Bildschirm, mehr Blickkontakt.", author: "MUSE", category: .general),
            QuoteData(text: "Ein gutes Buch schaltet die Welt kurz stumm.", author: "MUSE", category: .general),
            QuoteData(text: "Freundschaften brauchen Pflege, nicht Perfektion.", author: "MUSE", category: .general),
            QuoteData(text: "Gut geschlafen ist halb gewonnen.", author: "MUSE", category: .general),
            QuoteData(text: "Manchmal ist die beste Antwort: später.", author: "MUSE", category: .general),
            QuoteData(text: "Ordnung im Postfach, Ruhe im Kopf.", author: "MUSE", category: .general),
            QuoteData(text: "Der Ton entscheidet, nicht nur der Text.", author: "MUSE", category: .general),
            QuoteData(text: "Kleine Ziele für große Tage.", author: "MUSE", category: .general),
            QuoteData(text: "Ein Glas Wasser ist selten eine schlechte Idee.", author: "MUSE", category: .general),
            QuoteData(text: "Spontan ist schön, vorbereitet entspannter.", author: "MUSE", category: .general),
            QuoteData(text: "Gute Nachbarn sind stille Schätze.", author: "MUSE", category: .general),
            QuoteData(text: "Reisen bildet – Rückkehr erdet.", author: "MUSE", category: .general),
            QuoteData(text: "Musik sortiert Gefühle.", author: "MUSE", category: .general),
            QuoteData(text: "Ein Nein heute schützt dein Ja morgen.", author: "MUSE", category: .general),
            QuoteData(text: "Wetter ist Stimmung, Kleidung Entscheidung.", author: "MUSE", category: .general),
            QuoteData(text: "Geselligkeit ohne Drama ist Luxus.", author: "MUSE", category: .general),
            QuoteData(text: "Kaffeepausen retten Vormittage.", author: "MUSE", category: .general),
            QuoteData(text: "Zeit mit dir selbst ist keine Lücke.", author: "MUSE", category: .general),
            QuoteData(text: "Ordnung ist Freundlichkeit gegenüber dem Morgen.", author: "MUSE", category: .general),
            QuoteData(text: "Ein kurzer Anruf schlägt lange Missverständnisse.", author: "MUSE", category: .general),
            QuoteData(text: "Unverplante Stunden sind Atemräume.", author: "MUSE", category: .general),
            QuoteData(text: "Ein Spaziergang nach Regen ist Therapie gratis.", author: "MUSE", category: .general),

            // MARK: - Saufen / Drinking (50)
            QuoteData(text: "Auf die kleinen Siege – sie passen ins Glas.", author: "MUSE", category: .drinking),
            QuoteData(text: "Gute Geschichten beginnen selten mit Salat.", author: "MUSE", category: .drinking),
            QuoteData(text: "Ein Prost ersetzt keinen Plan, macht ihn aber charmanter.", author: "MUSE", category: .drinking),
            QuoteData(text: "Die beste Bar spielt deine Lieblingslieder von gestern.", author: "MUSE", category: .drinking),
            QuoteData(text: "Wasser zwischendurch ist Party-Erfahrung.", author: "MUSE", category: .drinking),
            QuoteData(text: "Wer anstößt, sagt kurz: Wir.", author: "MUSE", category: .drinking),
            QuoteData(text: "Cocktails sind Mathematik mit Sommer.", author: "MUSE", category: .drinking),
            QuoteData(text: "Die letzte Runde ist oft nicht die letzte.", author: "MUSE", category: .drinking),
            QuoteData(text: "Ein guter Barkeeper kennt Rezepte und Geschichten.", author: "MUSE", category: .drinking),
            QuoteData(text: "Feiern ist besser mit Heimweg-Plan.", author: "MUSE", category: .drinking),
            QuoteData(text: "Eisklirr klingt wie Wochenende.", author: "MUSE", category: .drinking),
            QuoteData(text: "Wein erklärt den Abend in Rot und Weiß.", author: "MUSE", category: .drinking),
            QuoteData(text: "Bier ist die unkomplizierte Freundschaft im Glas.", author: "MUSE", category: .drinking),
            QuoteData(text: "Shots übersetzen Mut sehr wörtlich.", author: "MUSE", category: .drinking),
            QuoteData(text: "Das beste Getränk ist das richtige Tempo.", author: "MUSE", category: .drinking),
            QuoteData(text: "Prost ist die kürzeste Verabredung.", author: "MUSE", category: .drinking),
            QuoteData(text: "Tanzen zählt als Sport, besonders mit Lächeln.", author: "MUSE", category: .drinking),
            QuoteData(text: "Kein Kater besiegt das Wasserglas am Abend.", author: "MUSE", category: .drinking),
            QuoteData(text: "Hausbar: Museum deiner Launen.", author: "MUSE", category: .drinking),
            QuoteData(text: "Longdrinks sind Geduld in hoher Form.", author: "MUSE", category: .drinking),
            QuoteData(text: "Gästeliste: alle, die du morgen noch magst.", author: "MUSE", category: .drinking),
            QuoteData(text: "Wenn die Musik dich trägt, trag deine Freunde mit.", author: "MUSE", category: .drinking),
            QuoteData(text: "Ein guter Abend weiß, wann er endet.", author: "MUSE", category: .drinking),
            QuoteData(text: "Mix it, aber übertreib’s nicht.", author: "MUSE", category: .drinking),
            QuoteData(text: "Sekt macht Pläne glitzern.", author: "MUSE", category: .drinking),
            QuoteData(text: "Die stille Stunde nach der Party ist Gold.", author: "MUSE", category: .drinking),
            QuoteData(text: "Barhocker sind Beichtstühle mit Musik.", author: "MUSE", category: .drinking),
            QuoteData(text: "Ehrliche Gespräche schmecken nach Tonic.", author: "MUSE", category: .drinking),
            QuoteData(text: "Der DJ entscheidet, wie viele Runden es werden.", author: "MUSE", category: .drinking),
            QuoteData(text: "Brauerei-Tour: Geografie für Erwachsene.", author: "MUSE", category: .drinking),
            QuoteData(text: "Tequila erklärt nichts, aber sofort.", author: "MUSE", category: .drinking),
            QuoteData(text: "Der beste Cocktail: gute Gesellschaft.", author: "MUSE", category: .drinking),
            QuoteData(text: "Zum Anstoßen braucht man Gründe – oder Freunde.", author: "MUSE", category: .drinking),
            QuoteData(text: "Bars sind Wohnzimmer mit besseren Geschichten.", author: "MUSE", category: .drinking),
            QuoteData(text: "Happy Hour: Mathe mit Rabatt.", author: "MUSE", category: .drinking),
            QuoteData(text: "Korkenknallen ist Akustik für Hoffnung.", author: "MUSE", category: .drinking),
            QuoteData(text: "Ein Gin erklärt die Botanik im Glas.", author: "MUSE", category: .drinking),
            QuoteData(text: "Alkoholfrei ist ein Tempo, nicht Verzicht.", author: "MUSE", category: .drinking),
            QuoteData(text: "Eisform bestimmt Laune und Länge.", author: "MUSE", category: .drinking),
            QuoteData(text: "Manche Abende sind Polaroids mit Musik.", author: "MUSE", category: .drinking),
            QuoteData(text: "Feiern endet, Freundschaft bleibt.", author: "MUSE", category: .drinking),
            QuoteData(text: "Shots sind Kommas, keine Punkte.", author: "MUSE", category: .drinking),
            QuoteData(text: "Die Lieblingsbar erkennt dich an der Frage.", author: "MUSE", category: .drinking),
            QuoteData(text: "Mix dir Erinnerungen, nicht Kopfschmerz.", author: "MUSE", category: .drinking),
            QuoteData(text: "Zuhause trinken ist günstiger, draußen lebendiger.", author: "MUSE", category: .drinking),
            QuoteData(text: "Ein guter Abend braucht ein gutes Morgen.", author: "MUSE", category: .drinking),
            QuoteData(text: "Klein anfangen, groß lachen.", author: "MUSE", category: .drinking),
            QuoteData(text: "Wer die Runde zahlt, erzält die Story.", author: "MUSE", category: .drinking),
            QuoteData(text: "Prost heißt: Wir teilen den Moment.", author: "MUSE", category: .drinking),

            // MARK: - Mindset (50)
            QuoteData(text: "Aus Fehlern baust du Geländer.", author: "MUSE", category: .mindset),
            QuoteData(text: "Entscheide, wer du morgens sein willst.", author: "MUSE", category: .mindset),
            QuoteData(text: "Neugier heilt starre Meinungen.", author: "MUSE", category: .mindset),
            QuoteData(text: "Die Gedanken, die du fütterst, wachsen.", author: "MUSE", category: .mindset),
            QuoteData(text: "Vergleiche dämpfen, Fortschritt feiern.", author: "MUSE", category: .mindset),
            QuoteData(text: "Selbstgespräche sind Programmcode fürs Leben.", author: "MUSE", category: .mindset),
            QuoteData(text: "Wähle Haltung vor Handlung – und dann handle.", author: "MUSE", category: .mindset),
            QuoteData(text: "Gelassenheit ist trainierbar.", author: "MUSE", category: .mindset),
            QuoteData(text: "Achtsamkeit spart Streit mit dir selbst.", author: "MUSE", category: .mindset),
            QuoteData(text: "Mut beginnt im Satz: Ich probiere es.", author: "MUSE", category: .mindset),
            QuoteData(text: "Zweifel sind Gäste, nicht Vermieter.", author: "MUSE", category: .mindset),
            QuoteData(text: "Du kannst nicht alles steuern, aber dich.", author: "MUSE", category: .mindset),
            QuoteData(text: "Fragen statt Vorwürfe – zuerst an dich.", author: "MUSE", category: .mindset),
            QuoteData(text: "Geduld ist Respekt gegenüber dem Prozess.", author: "MUSE", category: .mindset),
            QuoteData(text: "Klarheit entsteht, wenn du aufhörst zu verstecken.", author: "MUSE", category: .mindset),
            QuoteData(text: "Routinen sind Selbstführung in leise.", author: "MUSE", category: .mindset),
            QuoteData(text: "Akzeptanz öffnet Türen, Widerstand verbiegt sie.", author: "MUSE", category: .mindset),
            QuoteData(text: "Disziplin ist warmherzig, wenn sie dir dient.", author: "MUSE", category: .mindset),
            QuoteData(text: "Wähle Worte, die dich stärken.", author: "MUSE", category: .mindset),
            QuoteData(text: "Du bist Autor, nicht Zuschauer deiner Story.", author: "MUSE", category: .mindset),
            QuoteData(text: "Großzügigkeit macht reich – sofort.", author: "MUSE", category: .mindset),
            QuoteData(text: "Erwarte weniger von Tagen, mehr von dir.", author: "MUSE", category: .mindset),
            QuoteData(text: "Lernen beginnt, wenn Stolz schweigt.", author: "MUSE", category: .mindset),
            QuoteData(text: "Dein Fokus ist dein Filter.", author: "MUSE", category: .mindset),
            QuoteData(text: "Grenzen setzen ist Selbstschutz, nicht Strenge.", author: "MUSE", category: .mindset),
            QuoteData(text: "Wünsche sind Richtungen, Entscheidungen sind Schritte.", author: "MUSE", category: .mindset),
            QuoteData(text: "Ruhe ist ein Skill, der laut wirkt.", author: "MUSE", category: .mindset),
            QuoteData(text: "Kehre regelmäßig vor der eigenen Tür.", author: "MUSE", category: .mindset),
            QuoteData(text: "Lösungen lieben Verantwortliche.", author: "MUSE", category: .mindset),
            QuoteData(text: "Aktion nimmt Angst die Bühne.", author: "MUSE", category: .mindset),
            QuoteData(text: "Du darfst wachsen, auch wenn andere schauen.", author: "MUSE", category: .mindset),
            QuoteData(text: "Stärke hilft leise zuerst dir, dann allen.", author: "MUSE", category: .mindset),
            QuoteData(text: "Jeder Tag ist Beta – ship it.", author: "MUSE", category: .mindset),
            QuoteData(text: "Enttäuschung ist Liebe zur Realität.", author: "MUSE", category: .mindset),
            QuoteData(text: "Dein Umfeld ist Dünger – wähle ihn.", author: "MUSE", category: .mindset),
            QuoteData(text: "Notizen sind Gedanken in Sicherheit.", author: "MUSE", category: .mindset),
            QuoteData(text: "Hoffnung ist ein Muskel, trainiere sie.", author: "MUSE", category: .mindset),
            QuoteData(text: "Kleine Schritte sind Ehrlichkeit mit dir.", author: "MUSE", category: .mindset),
            QuoteData(text: "Wertschätzung beginnt im Spiegel.", author: "MUSE", category: .mindset),
            QuoteData(text: "Vergebung spart Zukunft.", author: "MUSE", category: .mindset),
            QuoteData(text: "Konsequenz ist Liebe in Taten.", author: "MUSE", category: .mindset),
            QuoteData(text: "Überzeuge dich durch Tun, nicht durch Denken.", author: "MUSE", category: .mindset),
            QuoteData(text: "Wachstum kratzt am Ego und stärkt das Selbst.", author: "MUSE", category: .mindset),
            QuoteData(text: "Loyalität zu dir ist keine Ausrede, sondern Führung.", author: "MUSE", category: .mindset),
            QuoteData(text: "Wähle täglich neu; das ist Freiheit.", author: "MUSE", category: .mindset),
            QuoteData(text: "Resilienz ist Hoffnung mit Werkzeugkoffer.", author: "MUSE", category: .mindset),
            QuoteData(text: "Güte ist eine Entscheidung, kein Zustand.", author: "MUSE", category: .mindset),
            QuoteData(text: "Energie folgt Aufmerksamkeit – halte sie sauber.", author: "MUSE", category: .mindset),
            QuoteData(text: "Sage häufiger Ja zu Verantwortung.", author: "MUSE", category: .mindset),
            QuoteData(text: "Akzeptiere Umstände, ändere Verhalten.", author: "MUSE", category: .mindset),



            
            
        ]
    }
    
    /// Fallback-Zitat falls keine Zitate verfügbar sind
    static var fallbackQuote: QuoteData {
        return QuoteData(
            text: "Großartige Dinge entstehen durch kleine Anfänge.",
            author: "- Deine MUSE -",
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
