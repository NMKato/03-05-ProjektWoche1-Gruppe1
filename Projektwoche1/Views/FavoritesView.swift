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

    // Nur als Favorit markierte Zitate laden
    @Query(
        filter: #Predicate<Quote> { $0.isFavorite == true },
        sort: \Quote.dateCreated, order: .reverse
    )
    private var favorites: [Quote]

    // Sheets
    @State private var showAddSheet = false

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
                        ForEach(favorites) { q in
                            QuoteCard(
                                quoteText: q.text,
                                author: q.author,
                                category: q.category,
                                background: .categoryGradient(q.category),
                                config: .init(showCategoryBadge: true, showActions: false),
                                onRefresh: nil,
                                onToggleFavorite: nil,
                                isFavorited: true
                            )
                            .listRowInsets(EdgeInsets()) // Karte über die volle Breite
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(Color.clear)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) { removeFromFavorites(q) } label: {
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
                    Button {
                        insertTenDemoFavorites()
                    } label: {
                        Label("10 Demo‑Zitate", systemImage: "wand.and.stars")
                    }
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
                // als Favorit speichern
                newQuote.isFavorite = true
                context.insert(newQuote)
                try? context.save()
            }
            .presentationDetents([.medium, .large])
        }
    }

    // MARK: - Aktionen

    /// Ent-favorisiert ein Zitat und entfernt zugehörige FavoriteQuote-Einträge.
    private func removeFromFavorites(_ quote: Quote) {
        withAnimation {
            quote.isFavorite = false
            // evtl. FavoriteQuote-Objekte wegräumen
            if let favs = try? context.fetch(FetchDescriptor<FavoriteQuote>()) {
                favs.filter { $0.quote.id == quote.id }.forEach { context.delete($0) }
            }
            try? context.save()
        }
    }

    /// Legt 10 Beispiel‑Zitate an (direkt als Favoriten).
    private func insertTenDemoFavorites() {
        let items: [(String, String, Category?)] = [
            ("Der beste Weg, die Zukunft vorherzusagen, ist, sie zu erschaffen.", "Peter Drucker", .motivation),
            ("Was immer du tun kannst oder träumst zu können, fang damit an.", "Goethe", .motivation),
            ("Zuerst löse das Problem. Dann schreibe den Code.", "John Johnson", .programming),
            ("Einfachheit ist die höchste Stufe der Vollendung.", "Leonardo da Vinci", .programming),
            ("Ich weiß, dass ich nichts weiß.", "Sokrates", .wisdom),
            ("Die einzige Konstante im Leben ist die Veränderung.", "Heraklit", .wisdom),
            ("Zeit, die wir uns nehmen, ist Zeit, die uns etwas gibt.", "Ernst Ferstl", .wisdom),
            ("Das Leben ist, was passiert, während du andere Pläne machst.", "John Lennon", .general),
            ("Sei du selbst die Veränderung, die du dir wünschst.", "Mahatma Gandhi", .general),
            ("Prost! Auf die guten Zeiten.", "Unbekannt", .drinking)
        ]

        withAnimation {
            for (text, author, cat) in items {
                let q = Quote(text: text, author: author, category: cat)
                q.isFavorite = true
                context.insert(q)
            }
            try? context.save()
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

    // ein paar Favoriten in der Preview
    let ex = Quote(text: "Preview‑Favorit", author: "Preview", category: .motivation)
    ex.isFavorite = true
    ctx.insert(ex)
    try? ctx.save()

    return FavoritesView()
        .modelContainer(container)
}
