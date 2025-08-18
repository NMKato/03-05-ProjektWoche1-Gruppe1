//
//  ReadMe.md
//  Projektwoche1
//
//  Created by Nikolas Kato on 18.08.25.
//

import Foundation


QuoteCraft
A native iOS app for displaying and managing inspirational quotes with favorites functionality, built with SwiftUI and SwiftData.
Overview
QuoteCraft is a modern iOS application that presents users with random quotes from various categories. The app demonstrates best practices in iOS development using SwiftUI, SwiftData, and MVVM architecture.
Features
Implemented

 Random quote display on app launch
 6 quote categories (Motivation, Wisdom, Programming, Drinking, Mindset, General)
 Favorites system for saving preferred quotes
 Persistent local storage with SwiftData
 Type-safe category management with enums
 MVVM architecture with clear separation of concerns

Planned

 User interface implementation
 Category filtering functionality
 Navigation between main and favorites views
 Quote sharing capabilities

Architecture
The app follows MVVM (Model-View-ViewModel) pattern with the following structure:
Models → Services → ViewModels → Views
   ↓        ↓          ↓         ↓
Quote   QuoteService QuoteVM   QuoteView
Category DataManager FavsVM    FavsView
Data Flow

QuoteService: Provides local quote data
DataManager: Handles SwiftData CRUD operations
ViewModels: Manage business logic and state
Views: SwiftUI user interface components

Project Structure
QuoteCraft/
├── Models/
│   ├── Quote.swift                 # SwiftData Quote model
│   ├── Category.swift              # Category enum definition
│   └── (FavoriteQuote in Quote.swift)
├── Services/
│   ├── QuoteService.swift          # Quote data provider
│   ├── DataManager.swift           # SwiftData operations
│   └── SwiftDataConfigurator.swift # Container setup
├── ViewModels/
│   ├── QuoteViewModel.swift        # Main quote logic
│   └── FavoritesViewModel.swift    # Favorites management
└── Views/
    ├── QuoteCraftApp.swift         # App entry point
    └── ContentView.swift           # Main navigation (planned)
Data Models
Quote
swift@Model
class Quote {
    @Attribute(.unique) var id: UUID
    var text: String
    var author: String
    var category: Category?
    var dateCreated: Date
    var isFavorite: Bool
}
FavoriteQuote
swift@Model
class FavoriteQuote {
    @Attribute(.unique) var id: UUID
    var quote: Quote
    var dateFavorited: Date
}
Category
swiftenum Category: String, CaseIterable {
    case motivation = "Motivation"
    case wisdom = "Weisheit"
    case programming = "Programmierung"
    case drinking = "Saufen"
    case mindset = "Mindset"
    case general = "Allgemein"
}
Technology Stack

Framework: SwiftUI (iOS 17+)
Database: SwiftData
Architecture: MVVM
Language: Swift 5.9+
Dependencies: None (native iOS only)

Requirements

Xcode 15.0 or later
iOS 17.0 or later
macOS 14.0 or later (for Simulator)



Development Progress
Phase 1: Foundation ✅

 Data models (Quote, FavoriteQuote, Category)
 Service layer (QuoteService, DataManager)
 SwiftData configuration and setup

Phase 2: Business Logic ✅

 ViewModels implementation
 Category enum migration
 Type-safe architecture

Phase 3: User Interface 🚧

 QuoteCardView component
 QuoteDisplayView main screen
 FavoritesView list screen
 ContentView navigation

Phase 4: Integration 🚧

 View navigation implementation
 UI/UX improvements
 Testing and optimization

Architecture Decisions
Why MVVM?

Clear separation between UI and business logic
Better testability and maintainability
Optimized for SwiftUI reactive patterns

Why SwiftData?

Native iOS integration with better performance
Type-safe database operations
Modern replacement for Core Data

Why Separate ViewModels?

Single Responsibility Principle
Performance optimization (isolated state updates)
Improved code maintainability and testing

Code Quality
The project emphasizes:

Type Safety: Enum-based categories, SwiftData models
Error Handling: Comprehensive error management
Documentation: Detailed code comments and documentation
Testing Support: Isolated components for unit testing

UML Diagram
The project includes a comprehensive UML diagram showing the complete architecture with all relationships between models, services, view models, and views.
Author
Nikolas Kato
Projektwoche 1 - August 18, 2025
License
Educational project - Not for commercial use

Last Updated: August 18, 2025 - Backend/Models implemented, Views in development
