//
//  ReadMe.md
//  Projektwoche1
//
//  Created by Nikolas Kato on 18.08.25.
//

QuoteCraft
<div align="center"> <img src="Assets.xcassets/AppIcon.imageset/AppIcon.png" alt="QuoteCraft Logo" width="120" height="120">
Eine intelligente iOS-App für personalisierte Zitate

Dein Moment. Dein Zitat. Clever kuratiert. Von MUSE.

</div>
📱 Über das Projekt
QuoteCraft ist eine iOS-App, die entwickelt wurde, um Nutzern passende Zitate basierend auf ihrer aktuellen Stimmung und ihrem Lebensbereich zu liefern. Die App wurde als einwöchiges Gruppenprojekt entwickelt und kombiniert moderne SwiftUI-Technologien mit einem durchdachten User Experience Design.

🎯 Hauptfunktionen
Stimmungsbasierte Zitat-Auswahl: Intelligente Algorithmen wählen Zitate basierend auf Nutzer-Stimmung (Freude, Traurig, Unsicher, Enttäuscht) und Lebensbereich (Arbeit, Freizeit, Privat)
MUSE Maskottchen: Ein interaktiver Papier-Fuchs, der die aktuelle Stimmung und den Kontext visuell darstellt
Favoriten-System: Speichern und organisieren von Lieblingszitaten nach Kategorien
Share-Funktionalität: Teilen von Zitaten über native iOS-Share-Optionen
Offline-First: Alle Zitate sind lokal verfügbar, keine Internetverbindung erforderlich
🏗️ Architektur
<div align="center"> <img src="Assets.xcassets/UML Diagram QutoeCraftApp.imageset/UML Diagram QutoeCraftApp.png" alt="UML Diagramm" width="600"> </div>
🛠️ Technischer Stack
Framework: SwiftUI (iOS 16+)
Datenpersistierung: SwiftData
Architektur: MVVM (Model-View-ViewModel)
UI-Design: Glassmorphism mit benutzerdefinierten Hintergründen
State Management: Combine Framework
📁 Projektstruktur
QuoteCraft/
├── Views/
│   ├── ContentView.swift          # Hauptansicht
│   ├── FavoritesView.swift        # Favoriten-Management
│   ├── QuoteCard.swift            # Wiederverwendbare Zitat-Karte
│   ├── LaunchScreenView.swift     # Animierter Startbildschirm
│   └── Components/
│       ├── MascotView.swift       # MUSE Maskottchen
│       └── CategoryHeaderView.swift
├── ViewModels/
│   ├── QuoteViewModel.swift       # Haupt-ViewModel
│   └── QuoteCardViewModel.swift   # Card-spezifische Logik
├── Models/
│   ├── Quote.swift               # SwiftData Models
│   ├── Category.swift            # Kategorien-Enum
│   ├── Mood.swift                # Stimmungs-Enum
│   └── LifeDomain.swift          # Lebensbereich-Enum
├── Services/
│   ├── QuoteService.swift        # Zitat-Bereitstellung
│   ├── DataManager.swift         # SwiftData Abstraktionsschicht
│   └── SwiftDataConfigurator.swift
└── Assets/
    ├── Backgrounds/              # Hintergrundbilder
    ├── Icons/                    # Kategorie-Icons
    └── MUSE/                     # Maskottchen-Assets
🎨 Design-Features
Adaptive UI-Elemente
Glassmorphism-Design: Transparente UI-Elemente mit Blur-Effekten
Kategoriebasierte Farbschemata: Jede Zitat-Kategorie hat eigene Gradient-Farben
Responsive Layout: Optimiert für verschiedene iPhone-Größen
Dark Mode Support: Vollständige Unterstützung für dunkles Design
Interaktive Komponenten
Animated Launch Screen: Professioneller Startbildschirm mit Progress-Animation
Swipe Actions: Intuitive Gesten für Favoriten-Management
Smooth Transitions: Flüssige Übergänge zwischen Views
Custom Buttons: Einzigartige Blatt-Button-Designs
🧠 Intelligente Zitat-Auswahl
Die App verwendet einen gewichteten Algorithmus zur Zitat-Auswahl:

swift
// Beispiel der Gewichtsmatrix
switch (mood, domain) {
case (.freude, .leisure):
    return [(.general, 4), (.wisdom, 3), (.mindset, 3), (.motivation, 2)]
case (.traurig, .work):
    return [(.motivation, 5), (.mindset, 4), (.wisdom, 3)]
// ... weitere Kombinationen
}
📊 Daten & Kategorien
Verfügbare Kategorien
Motivation (🚀): Inspirierende Zitate für neue Energie
Weisheit (🧠): Philosophische Erkenntnisse und Lebensweisheiten
Programmierung (💻): Zitate für Entwickler und Tech-Enthusiasten
Mindset (🧘‍♂️): Persönlichkeitsentwicklung und Denkweise
Allgemein (💭): Universell anwendbare Zitate
Saufen (🍺): Humorvolle Zitate rund ums Feiern
Zitat-Sammlung
150+ kuratierte Zitate von klassischen und modernen Autoren
Eigene MUSE-Zitate: Speziell für die App entwickelte, prägnante Weisheiten
Mehrsprachig: Primär deutsche Zitate mit internationalen Quellen
🚀 Installation & Setup
Voraussetzungen
Xcode 15.0+
iOS 16.0+
Swift 5.9+
Installation
Repository klonen:
bash

cd QuoteCraft
Projekt in Xcode öffnen:
bash
open QuoteCraft.xcodeproj
Build und Run auf Simulator oder Gerät
Erste Schritte
App starten und Launch-Animation genießen
Stimmung und Lebensbereich auswählen
Erstes personalisiertes Zitat erhalten
Favoriten durch Stern-Button hinzufügen
MUSE-Favoriten-Sektion erkunden
👥 Team & Entwicklung
Entwicklungsteam:

Nikolas Kato - Lead Developer & UI/UX Design
Florica Girisci - View Development & Component Architecture
Waldemar Dietler - Data Management & Backend Logic
Entwicklungszeitraum: 1 Woche intensives Gruppenprojekt

Projektmethodik:

Agile Entwicklung mit täglichen Stand-ups
Git Flow für Versionskontrolle
Code Reviews und Pair Programming
Iterative UI/UX-Verbesserungen
🔧 Technische Highlights
SwiftData Integration
swift
@Model
final class Quote {
    @Attribute(.unique) var id: UUID
    var text: String
    var author: String
    var category: Category?
    var dateCreated: Date
    var isFavorite: Bool
}
Reactive UI mit Combine
swift
@MainActor
final class QuoteViewModel: ObservableObject {
    @Published var currentQuote: Quote?
    @Published var selectedMood: Mood = .freude
    @Published var selectedDomain: LifeDomain = .work
}
Custom ViewModifier für Glassmorphism
swift
.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
.overlay(RoundedRectangle(cornerRadius: 12)
    .strokeBorder(.white.opacity(0.18), lineWidth: 0.5))
📈 Zukünftige Entwicklungen
 iCloud Sync für Favoriten
 Widget Support für iOS Home Screen
 Apple Watch Companion App
 Benutzerdefinierte Zitat-Kategorien
 Social Sharing mit Custom Cards
 Accessibility-Verbesserungen
 Internationalisierung (EN, FR, ES)
📄 Lizenz
Dieses Projekt wurde als Bildungsprojekt entwickelt. Alle Rechte vorbehalten.

🤝 Mitwirken
Da dies ein abgeschlossenes Gruppenprojekt ist, sind Pull Requests derzeit nicht geöffnet. Bei Fragen oder Anregungen können Issues erstellt werden.

<div align="center"> <p><strong>QuoteCraft</strong> - Wo Technologie auf Inspiration trifft</p> <p>Entwickelt mit ❤️ in Deutschland</p> </div>
