//
//  Projektwoche1App.swift
//  Projektwoche1
//
//  Created by Nikolas Kato 18.08.2025
//

import SwiftUI
import SwiftData

// MARK: - QuoteCraftApp
/// Haupt-App Struktur für QuoteCraft
/// Konfiguriert SwiftData Container und initialisiert App-Dependencies
import SwiftUI
import SwiftData

@main
struct QuoteCraftApp: App {

    // MARK: - Dependencies
    private let modelContainer: ModelContainer
    @StateObject private var dataManager: DataManager
    @StateObject private var quoteViewModel: QuoteViewModel
    @StateObject private var favoritesViewModel: FavoritesViewModel
    @State private var isLaunchComplete = false

    init() {
        // 1) Container einmal erstellen und behalten
        let container = SwiftDataConfigurator.createQuoteCraftContainer()
        self.modelContainer = container

        // 2) DataManager & VMs mit demselben Container/Context aufsetzen
        let dm = DataManager(modelContext: container.mainContext)
        _dataManager = StateObject(wrappedValue: dm)
        _quoteViewModel = StateObject(wrappedValue: QuoteViewModel(dataManager: dm))
        _favoritesViewModel = StateObject(wrappedValue: FavoritesViewModel(dataManager: dm))
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                AppBackground()
                if !isLaunchComplete {
                    LaunchScreenView(isLaunchComplete: $isLaunchComplete)
                        .transition(.opacity.combined(with: .scale))
                } else {
                    MainTabView()
                        .transition(.opacity)
                }
            }
            .environmentObject(dataManager)
            .environmentObject(quoteViewModel)
            .environmentObject(favoritesViewModel)
            .task { await initializeApp() }
        }
        .modelContainer(modelContainer)                    
    }
}


// MARK: - App Initialization
private extension QuoteCraftApp {
    
    /// Initialisiert die App beim ersten Start
    /// Führt Setup-Tasks aus die nach App-Launch benötigt werden
    func initializeApp() async {
        print("QuoteCraft App wird initialisiert...")
        
        // Prüfe ob bereits Daten vorhanden sind
        await checkForExistingData()
        
        // Weitere Initialisierung hier möglich:
        // - Analytics Setup
        // - Crash Reporting
        // - User Defaults Migration
        // - etc.
        
        print("QuoteCraft App erfolgreich initialisiert!")
    }
    
    /// Prüft ob bereits Quotes oder Favoriten in der Datenbank vorhanden sind
    /// Kann für zukünftige Migrations-Logic verwendet werden
    func checkForExistingData() async {
        do {
            let existingQuotes = try dataManager.getAllSavedQuotes()
            let existingFavorites = try dataManager.getFavoriteQuotes()
            
            print("Gefunden: \(existingQuotes.count) gespeicherte Quotes")
            print(" Gefunden: \(existingFavorites.count) Favoriten")
            
            // Zukünftige Logic für Daten-Migration oder Setup hier
            
        } catch {
            print("Warnung beim Prüfen vorhandener Daten: \(error)")
            // Nicht kritisch - App kann trotzdem starten
        }
    }
}

// MARK: - Debug Helpers
#if DEBUG
extension QuoteCraftApp {
    
    /// Debug-Helper um Container-Informationen zu loggen
    /// Nur in Debug-Builds verfügbar
    static func logContainerInfo(_ container: ModelContainer) {
        print("🗃️ ModelContainer erstellt")
        
        // Schritt-für-Schritt Configuration-Behandlung
        guard let configuration = container.configurations.first else {
            print("Container URL: No configuration found")
            print("In Memory: Unknown")
            return
        }
        
        // URL ist nicht optional in ModelConfiguration
        print("Container URL: \(configuration.url.absoluteString)")
        
        // Memory-Status
        print("In Memory: \(configuration.isStoredInMemoryOnly)")
    }
}
#endif
