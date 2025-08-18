//
//  Category.swift
//  Projektwoche1
//
//  Created by Nikolas Kato on 18.08.25.
//

import Foundation

// MARK: - Category Enum
/// Definiert alle verfügbaren Zitat-Kategorien in der App
/// Gewährleistet Type-Safety und verhindert Tippfehler
enum Category: String, CaseIterable, Codable {
    
    // MARK: - Cases
    
    /// Motivierende und inspirierende Zitate
    case motivation = "Motivation"
    
    /// Philosophische und weise Sprüche
    case wisdom = "Weisheit"
    
    /// Zitate über Programmierung und Technologie
    case programming = "Programmierung"
    
    /// Allgemeine Zitate ohne spezifische Kategorie
    case general = "Allgemein"
    
    /// Lustige Sprüche rund ums Trinken und Feiern
    case drinking = "Saufen"
    
    /// Zitate über Denkweise und Persönlichkeitsentwicklung
    case mindset = "Mindset"
    
    // MARK: - Computed Properties
    
    /// Benutzerfreundlicher Display-Name
    var displayName: String {
        return self.rawValue
    }
    
    /// Emoji-Icon für die Kategorie
    var icon: String {
        switch self {
        case .motivation:
            return "🚀"
        case .wisdom:
            return "🧠"
        case .programming:
            return "💻"
        case .general:
            return "💭"
        case .drinking:
            return "🍺"
        case .mindset:
            return "🧘‍♂️"
        }
    }
    
    /// Beschreibung der Kategorie
    var description: String {
        switch self {
        case .motivation:
            return "Inspirierende Zitate die zum Handeln motivieren"
        case .wisdom:
            return "Philosophische Weisheiten und Lebenserkenntnisse"
        case .programming:
            return "Zitate über Technologie und Softwareentwicklung"
        case .general:
            return "Allgemeine Zitate für alle Lebenslagen"
        case .drinking:
            return "Lustige und gesellige Sprüche rund ums Trinken"
        case .mindset:
            return "Zitate über Denkweise und persönliche Entwicklung"
        }
    }
    
    /// Hintergrundfarbe für UI (später verwendbar)
    var colorName: String {
        switch self {
        case .motivation:
            return "orange"
        case .wisdom:
            return "blue"
        case .programming:
            return "green"
        case .general:
            return "gray"
        case .drinking:
            return "yellow"
        case .mindset:
            return "purple"
        }
    }
}

// MARK: - Category Extensions
extension Category {
    
    /// Zufällige Kategorie auswählen
    static var random: Category {
        return Category.allCases.randomElement() ?? .general
    }
    
    /// Kategorie aus String erstellen (Safe Conversion)
    /// - Parameter string: String-Wert der Kategorie
    /// - Returns: Category falls gefunden, sonst nil
    static func from(string: String?) -> Category? {
        guard let string = string else { return nil }
        return Category(rawValue: string)
    }
}

// MARK: - Legacy String Support
extension Category {
    
    /// Konvertiert Legacy-String zu Category
    /// Für Migration von String-basiert zu Enum-basiert
    /// - Parameter legacyString: Alter String-Wert
    /// - Returns: Entsprechende Category oder .general als Fallback
    static func fromLegacyString(_ legacyString: String?) -> Category {
        guard let string = legacyString else { return .general }
        
        switch string.lowercased() {
        case "motivation":
            return .motivation
        case "weisheit":
            return .wisdom
        case "programmierung":
            return .programming
        case "saufen":
            return .drinking
        case "mindset":
            return .mindset
        default:
            return .general
        }
    }
}
