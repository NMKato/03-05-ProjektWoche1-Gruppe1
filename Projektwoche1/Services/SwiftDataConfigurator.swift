//
//  SwiftDataConfigurator.swift
//  Projektwoche1
//
//  Created by Nikolas Kato on 18.08.25.
//

import Foundation
import SwiftData

// MARK: - SwiftDataConfigurator
/// Zentrale Konfiguration für SwiftData ModelContainer
/// Abstrahiert SwiftData-Setup von der App-Struktur
struct SwiftDataConfigurator {
    
    // MARK: - Container Creation
    
    /// Erstellt und konfiguriert den ModelContainer für QuoteCraft
    /// - Returns: Konfigurierter ModelContainer für Quote und FavoriteQuote
    /// - Throws: ModelContainer-Erstellungsfehler
    static func createQuoteCraftContainer() -> ModelContainer {
        // Definiere Schema für QuoteCraft Models
        let schema = createQuoteCraftSchema()
        
        // Konfiguriere ModelContainer für Production
        let modelConfiguration = createProductionConfiguration(schema: schema)
        
        do {
            // Erstelle Container mit Production-Konfiguration
            let container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
            
            return container
            
        } catch {
            // Fallback: In-Memory Container bei Fehlern
            print("Fehler beim Erstellen des ModelContainers: \(error)")
            print("Verwende In-Memory Container als Fallback")
            
            return createFallbackContainer(schema: schema)
        }
    }
    
    // MARK: - Schema Configuration
    
    /// Erstellt das SwiftData Schema für alle QuoteCraft Models
    /// - Returns: Konfiguriertes Schema mit allen benötigten Models
    private static func createQuoteCraftSchema() -> Schema {
        return Schema([
            Quote.self,
            FavoriteQuote.self
        ])
    }
    
    // MARK: - Configuration Creation
    
    /// Erstellt Production ModelConfiguration
    /// - Parameter schema: Das zu verwendende Schema
    /// - Returns: Konfigurierte ModelConfiguration für Production
    private static func createProductionConfiguration(schema: Schema) -> ModelConfiguration {
        return ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,  // Persistente Speicherung
            cloudKitDatabase: .none       // Lokal, ohne CloudKit
        )
    }
    
    /// Erstellt In-Memory ModelConfiguration als Fallback
    /// - Parameter schema: Das zu verwendende Schema
    /// - Returns: Konfigurierte ModelConfiguration für In-Memory
    private static func createInMemoryConfiguration(schema: Schema) -> ModelConfiguration {
        return ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: true    // Nur im Arbeitsspeicher
        )
    }
    
    // MARK: - Fallback Container
    
    /// Erstellt einen Fallback-Container bei Fehlern
    /// - Parameter schema: Das zu verwendende Schema
    /// - Returns: In-Memory ModelContainer als letzter Ausweg
    private static func createFallbackContainer(schema: Schema) -> ModelContainer {
        let fallbackConfiguration = createInMemoryConfiguration(schema: schema)
        
        do {
            return try ModelContainer(
                for: schema,
                configurations: [fallbackConfiguration]
            )
        } catch {
            fatalError("💥 Kritischer Fehler: Kann keinen ModelContainer erstellen: \(error)")
        }
    }
}

// MARK: - Testing Support
#if DEBUG
extension SwiftDataConfigurator {
    
    /// Erstellt einen Test-Container mit In-Memory Storage
    /// Für Unit-Tests und UI-Tests
    /// - Returns: In-Memory ModelContainer für Testing
    static func createTestContainer() -> ModelContainer {
        let schema = createQuoteCraftSchema()
        let testConfiguration = createInMemoryConfiguration(schema: schema)
        
        do {
            return try ModelContainer(
                for: schema,
                configurations: [testConfiguration]
            )
        } catch {
            fatalError("💥 Test-Container konnte nicht erstellt werden: \(error)")
        }
    }
    
    /// Erstellt einen Mock-Container mit vorgefüllten Test-Daten
    /// Für SwiftUI Previews und Demo-Zwecke
    /// - Returns: In-Memory ModelContainer mit Sample-Daten
    @MainActor
    static func createPreviewContainer() -> ModelContainer {
        let container = createTestContainer()
        
        // Füge Sample-Daten für Previews hinzu
        let context = container.mainContext
        
        // Sample Quote erstellen
        let sampleQuote = Quote(
            text: "Preview-Zitat für SwiftUI Previews",
            author: "SwiftDataConfigurator",
            category: .motivation
        )
        
        context.insert(sampleQuote)
        
        try? context.save()
        
        return container
    }
}
#endif
