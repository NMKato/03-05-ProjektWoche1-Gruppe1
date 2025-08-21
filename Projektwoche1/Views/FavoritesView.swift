//
//  FavoritesView.swift
//  Projektwoche1
//
//  Created by Waldemar Dietler on 20.08.25.
//

import SwiftUI
import SwiftData

// MARK: - Favoriten Verwaltung
struct FavoritesView: View {
    @Environment(\.modelContext) private var context

    // SwiftData Query für Favoriten
    @Query(
        filter: #Predicate<Quote> { $0.isFavorite == true },
        sort: \Quote.dateCreated, order: .reverse
    )
    private var favorites: [Quote]

    // UI State 
    @State private var showAddSheet = false
    @State private var expandedCategories: Set<Category> = []
    
    // Fullscreen State
    @State private var fullscreenQuote: Quote? = nil

    // Services
    private var dataManager: DataManager {
        DataManager(modelContext: context)
    }

    // Gruppierte Favoriten
    private var groupedFavorites: [Category: [Quote]] {
        Dictionary(grouping: favorites) { $0.category ?? .general }
    }

    var body: some View {
        NavigationStack {
            Group {
                if favorites.isEmpty {
                    emptyStateView
                } else {
                    favoritesList
                }
            }
            .navigationTitle("Favoriten")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddSheet = true
                    } label: {
                        Label("Neues Zitat", systemImage: "plus")
                    }
                }
            }
        }
        .background {
            AppBackground()
        }
        .sheet(isPresented: $showAddSheet) {
            AddQuoteSheet { newQuote in
                saveNewQuote(newQuote)
            }
            .presentationDetents([.medium, .large])
        }
        .fullScreenCover(item: $fullscreenQuote) { quote in
            FullscreenQuoteView(quote: quote, dataManager: dataManager)
        }
    }
}

// MARK: - Subviews
private extension FavoritesView {
    
    var emptyStateView: some View {
        ContentUnavailableView(
            "Keine Favoriten",
            systemImage: "star",
            description: Text("Tippe auf den Stern in der Hauptansicht oder füge neue Zitate hier hinzu.")
        )
    }
    
    var favoritesList: some View {
        List {
            ForEach(sortedCategories, id: \.self) { category in
                categorySection(for: category)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
    }
    
    private var sortedCategories: [Category] {
        Array(groupedFavorites.keys).sorted { $0.rawValue < $1.rawValue }
    }
    
    func categorySection(for category: Category) -> some View {
        DisclosureGroup(
            isExpanded: Binding(
                get: { expandedCategories.contains(category) },
                set: { isExpanded in
                    toggleCategory(category, isExpanded: isExpanded)
                }
            )
        ) {
            categoryContent(for: category)
        } label: {
            CategoryHeaderView(
                category: category,
                count: groupedFavorites[category]?.count ?? 0
            )
        }
    }
    
    func categoryContent(for category: Category) -> some View {
        ForEach(groupedFavorites[category] ?? []) { quote in
            QuoteCard(
                quote: quote,
                dataManager: dataManager,
                quoteService: nil,
                config: .init(showCategoryBadge: false, showActions: false),
                backgroundStyle: .categoryGradient(quote.category)
            )
            .onTapGesture {
                openFullscreen(quote: quote)
            }
            .listRowInsets(EdgeInsets())
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    removeFromFavorites(quote)
                } label: {
                    Label("Löschen", systemImage: "trash")
                }
            }
        }
    }
}

// MARK: - Actions
private extension FavoritesView {
    
    func toggleCategory(_ category: Category, isExpanded: Bool) {
        withAnimation(.easeInOut(duration: 0.3)) {
            if isExpanded {
                expandedCategories.insert(category)
            } else {
                expandedCategories.remove(category)
            }
        }
    }
    
    func openFullscreen(quote: Quote) {
        fullscreenQuote = quote
    }
    
    func removeFromFavorites(_ quote: Quote) {
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
    
    func saveNewQuote(_ newQuote: Quote) {
        newQuote.isFavorite = true
        context.insert(newQuote)
        try? context.save()
    }
}

// MARK: - Add Quote Sheet
private struct AddQuoteSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var text: String = ""
    @State private var author: String = ""
    @State private var category: Category? = nil
    
    let onSave: (Quote) -> Void
    
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
                        saveQuote()
                    }
                    .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
    
    private func saveQuote() {
        let quote = Quote(
            text: text.trimmingCharacters(in: .whitespacesAndNewlines),
            author: author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Unbekannt" : author,
            category: category
        )
        onSave(quote)
        dismiss()
    }
}

// MARK: - Preview
#Preview {
    let container = SwiftDataConfigurator.createPreviewContainer()
    let ctx = container.mainContext
    
    // Preview-Favorit
    let previewQuote = Quote(text: "Preview-Favorit", author: "Preview", category: .motivation)
    previewQuote.isFavorite = true
    ctx.insert(previewQuote)
    try? ctx.save()
    
    return FavoritesView()
        .modelContainer(container)
}
