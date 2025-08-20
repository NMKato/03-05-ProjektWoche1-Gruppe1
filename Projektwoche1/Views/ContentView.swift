//
//  ContentView.swift
//  Projektwoche1
//
//    Created by Nikolas Kato 18.08.2025
//    Created by Florica Girisci 19.08.2025
//    Created by Waldemar Dietler 20.08.2025

import SwiftUI
import SwiftData

struct ContentView: View {
    
    // MARK: - Dependencies (Abhängigkeiten/Zugehörigkeiten)
    @EnvironmentObject private var quoteVM: QuoteViewModel
    @State private var showFavorites = false
    
    // MARK: - View
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                //Ladezustand
                if quoteVM.isLoading {
                    ProgressView("Zitat wird geladen...")
                    
                    
                }
                // Zitat vorhanden
                else if let q = quoteVM.currentQuote {
                    QuoteCard(quoteText: q.text,
                              author: q.author,
                              category: q.category,
                              background: .categoryGradient(q.category),
                              config: .init(showCategoryBadge: true, showActions: true),
                              onRefresh: { quoteVM.refreshQuote()},
                              onToggleFavorite: { quoteVM.toggleFavorite()},
                              isFavorited: quoteVM.isFavorited
                    )
                    .padding(.horizontal)
                    
                    
                }
                
                // falls kein Zitat (fallback)
                else {
                    ContentUnavailableView(
                        "Kein Zitat", systemImage: "quote.bubble",
                        description: Text("Tippen Sie auf 'neues Zitat'.")
                    )
                }
                // FehlerMeldung optional
                if let msg = quoteVM.errorMessage {
                    Text(msg)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .padding(.top, 4)
                }
                
                Spacer()
                
            }
            .padding()
            .navigationTitle("Quote Craft")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showFavorites = true
                    } label: {
                        Image(systemName: "star.fill")
                    }
                    .accessibilityLabel("Favoriten anzeigen")
                }
            }
            
        }
        .task {
            // 1.Zitat bei startladen
            if quoteVM.currentQuote == nil {
                quoteVM.loadRandomQuote()
            }
        }
        .sheet(isPresented: $showFavorites) {
            FavoritesView()
        }
    }
}
// MARK: - Preview
#Preview {
    // 1. in memoryContainer für previews
    let container = SwiftDataConfigurator.createPreviewContainer()
    
    // 2. DataManager mit PreviewContext
    let dm = DataManager(modelContext: container.mainContext)
    
    // 3. QuoteModel erzeugen
    let vm = QuoteViewModel(dataManager: dm)
    
    // 4. Stabil Beispiel Zitat setzen
    vm.currentQuote = Quote(text: "Preview Zitat: stabil, sichtbar", author: "Preview Autor", category: .motivation)
    vm.isFavorited = false
    
    // 5. view + EnvironmentObjekt
    return ContentView()
        .environmentObject(vm)
        .modelContainer(container)
    
    
    
}
