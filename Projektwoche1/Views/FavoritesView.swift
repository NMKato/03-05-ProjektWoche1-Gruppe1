//
//  FavoritesView.swift
//  Projektwoche1
//
//  Created by Waldemar Dietler on 20.08.25.
//

import SwiftUI
import SwiftData

// MARK: - Liste & Verwaltung der Favoriten
struct FavoritesView: View {
    @Environment(\.modelContext) private var context

    // SwiftData Query für reaktive UI-Updates
    @Query(
        filter: #Predicate<Quote> { $0.isFavorite == true },
        sort: \Quote.dateCreated, order: .reverse
    )
    private var favorites: [Quote]

    // UI State
    @State private var showAddSheet = false
    @State private var isCreatingDemoData = false

    // Services
    private var dataManager: DataManager {
        DataManager(modelContext: context)
    }
    
    private var quoteService: QuoteService {
        QuoteService()
    }

    var body: some View {
        NavigationStack {
            Group {
                if favorites.isEmpty {
                    ContentUnavailableView(
                        "Keine Favoriten",
                        systemImage: "star",
                        description: Text("Tippe auf den Stern in der Hauptansicht oder füge neue Zitate hier hinzu.")
                    )
                } else {
                    List {
                        ForEach(favorites) { quote in
                            QuoteCard(
                                quote: quote,
                                dataManager: dataManager,
                                quoteService: nil, // Keine Refresh-Funktion in Favoriten
                                config: .init(showCategoryBadge: true, showActions: false),
                                backgroundStyle: .categoryGradient(quote.category)
                            )
                            .listRowInsets(EdgeInsets())
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(Color.clear)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    removeFromFavorites(quote)
                                } label: {
                                    Label("Löschen", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Favoriten (\(favorites.count))")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
    /*
                    Button {
                        createDemoFavorites()
                    } label: {
                        HStack(spacing: 4) {
                            if isCreatingDemoData {
                                ProgressView()
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "wand.and.stars")
                            }
                            Text("10 Demo-Zitate")
                        }
                    }
                    .disabled(isCreatingDemoData)
    */
                    Button {
                        showAddSheet = true
                    } label: {
                        Label("Neues Zitat", systemImage: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddQuoteSheet { newQuote in
                // Als Favorit speichern
                newQuote.isFavorite = true
                context.insert(newQuote)
                try? context.save()
            }
            .presentationDetents([.medium, .large])
        }
    }

    // MARK: - Aktionen

    /// Entfernt ein Zitat aus den Favoriten
    /// - Parameter quote: Das zu entfernende Quote
    private func removeFromFavorites(_ quote: Quote) {
        withAnimation {
            quote.isFavorite = false
            
            // Entferne zugehörige FavoriteQuote-Einträge
            if let favoriteQuotes = try? context.fetch(FetchDescriptor<FavoriteQuote>()) {
                favoriteQuotes
                    .filter { $0.quote.id == quote.id }
                    .forEach { context.delete($0) }
            }
            
            try? context.save()
        }
    }
 
    
    
    /// Erstellt 10 Demo-Favoriten aus dem QuoteService
    /// Verwendet echte Zitate statt hartcodierte Demo-Daten
    private func createDemoFavorites() {
        guard !isCreatingDemoData else { return }
        
        isCreatingDemoData = true
        
        // Verwende Task für async Operationen
        Task {
            defer {
                Task { @MainActor in
                    isCreatingDemoData = false
                }
            }
            
            await MainActor.run {
                let allQuotes = quoteService.getAllQuotes()
                let selectedQuotes = Array(allQuotes.shuffled().prefix(10))
                
                withAnimation {
                    for quote in selectedQuotes {
                        // Prüfe ob bereits favorisiert
                        if !dataManager.isQuoteFavorited(quote) {
                            quote.isFavorite = true
                            context.insert(quote)
                            
                            // Erstelle auch FavoriteQuote-Eintrag
                            let favoriteQuote = FavoriteQuote(quote: quote)
                            context.insert(favoriteQuote)
                        }
                    }
                    
                    try? context.save()
                }
            }
        }
    }
}

// MARK: - Sheet zum manuellen Anlegen eines Zitats
private struct AddQuoteSheet: View {
    @Environment(\.dismiss) private var dismiss

    @State private var text: String = ""
    @State private var author: String = ""
    @State private var category: Category? = nil

    var onSave: (Quote) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Zitat") {
                    TextField("Text", text: $text, axis: .vertical)
                        .lineLimit(3...6)
                    TextField("Autor:in", text: $author)
                }
                Section("Kategorie (optional)") {
                    Picker("Kategorie", selection: Binding(
                        get: { category ?? .general },
                        set: { newVal in category = newVal }
                    )) {
                        Text("Keine").tag(Category?.none)
                        ForEach(Category.allCases, id: \.self) { c in
                            Text("\(c.icon)  \(c.displayName)").tag(c)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
            }
            .navigationTitle("Neues Zitat")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Sichern") {
                        let q = Quote(
                            text: text.trimmingCharacters(in: .whitespacesAndNewlines),
                            author: author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Unbekannt" : author,
                            category: category
                        )
                        onSave(q)
                        dismiss()
                    }
                    .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    let container = SwiftDataConfigurator.createPreviewContainer()
    let ctx = container.mainContext

    // Ein paar Favoriten in der Preview
    let ex = Quote(text: "Preview-Favorit", author: "Preview", category: .motivation)
    ex.isFavorite = true
    ctx.insert(ex)
    try? ctx.save()

    return FavoritesView()
        .modelContainer(container)
}
