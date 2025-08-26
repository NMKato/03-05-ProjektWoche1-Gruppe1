//
//  ContentView.swift
//  Projektwoche1
//
//  Created by Nikolas Kato 18.08.2025
//  Created by Florica Girisci 19.08.2025
//  Created by Waldemar Dietler 20.08.2025

import SwiftUI
import SwiftData

struct ContentView: View {
    
    // MARK: - Dependencies
    @EnvironmentObject private var quoteVM: QuoteViewModel
    @Environment(\.modelContext) private var modelContext
    
    @State private var shareImage: UIImage? = nil
    @State private var showShareSheet = false
    @State private var showInfoSheet = false

    
    // MARK: - Computed Properties
    private var dataManager: DataManager {
        DataManager(modelContext: modelContext)
    }
    
    private var quoteService: QuoteService {
        QuoteService()
    }
    
    private func shareCurrentQuoteAsImage() {
        guard let q = quoteVM.currentQuote else { return }

        // 9:16 – Social/Story-freundlich; alternativ 1080x1080
        let canvas = ShareQuoteView(
            text: q.text,
            author: q.author,
            category: q.category,
            backgroundAsset: "MUSE_Share_Design"
        )
        let targetSize = CGSize(width: 1080, height: 1920)

        if let img = ShareRenderer.render(view: canvas, size: targetSize) {
            shareImage = img
            showShareSheet = true
        }
    }

    
    
    // MARK: - View
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                // Header mit Maskottchen
                headerSection
                
                // Stimmung & Bereich Auswahl
                selectionSection
                
                // Hauptinhalt: Zitat oder Loading
                mainContentSection
                
                // Fehlermeldung
                errorSection
                
                Spacer()
                
                // Info Button unten links
                HStack {
                    Button {
                        showInfoSheet = true
                    } label: {
                        
                        Image(systemName: "info.circle")
                            .font(.title2)
                            .foregroundStyle(.white.opacity(0.6))
                    }
                    .accessibilityLabel("App-Informationen anzeigen")
                    
                    Spacer()
                }
               .padding()
            }
           // .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        quoteVM.showFavoritesSheet()
                    } label: {
                        Text("MUSE ")
                            .foregroundStyle(.white)
                        Image(systemName: "heart.fill")
                        
                    }
                    .accessibilityLabel("Favoriten anzeigen")
                    .foregroundColor(.orange)
                }
            }
            .background { AppBackground() }
          
        }
        .task {
            // Erstes Zitat laden falls keines vorhanden
            if quoteVM.currentQuote == nil {
                quoteVM.loadRandomQuote()
            }
        }
        .sheet(isPresented: $quoteVM.showFavorites) {
            FavoritesView()
        }
        .sheet(isPresented: $showInfoSheet) {
            InfoView()
        }
    }
}

// MARK: - Subviews
private extension ContentView {
    
    var headerSection: some View {
        HStack {
            MascotView(
                mood: quoteVM.selectedMood,
                domain: quoteVM.selectedDomain,
                size: 64
            )
            VStack(alignment: .leading, spacing: 2) {
                Text("„Dein Moment. Dein Zitat.“")
                    .font(.headline)
                    .foregroundStyle(.white)
                Text("Clever kuratiert. Von MUSE..")
                    .font(.caption)
                    .foregroundStyle(.white)
            }
            Spacer()
        }
        .frame(width: 370)
        .padding(.bottom, 6)
    }
    
    var selectionSection: some View {
        Group {
            // Stimmung Picker
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Stimmung")
                        .font(.caption)
                        .foregroundStyle(.white)
                    Spacer()
                    // Aktueller Status anzeigen
                    Text(quoteVM.currentSelectionText)
                        .font(.caption2)
                        .foregroundStyle(.white)
                }
                .frame(width: 360)
                
                // Stimmung (Glas-Look um den Segmented-Picker)
                Picker("Stimmung", selection: $quoteVM.selectedMood) {
                    ForEach(Mood.allCases, id: \.self) { mood in
                        Text(mood.displayName).tag(mood)
                        
                    }
                }
                .frame(width: 360)
                .pickerStyle(.segmented)
                .tint(.white) // Segment-Farbe auf hellem/dunklem Hintergrund anpassen
                .padding(6)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(.white.opacity(0.18), lineWidth: 0.5)
                )
                .shadow(color: .black.opacity(0.25), radius: 10, y: 3)
                .onChange(of: quoteVM.selectedMood) { _, newMood in
                    quoteVM.updateMood(newMood)
                }
            }
            
            // Bereich Picker (Glass-Look um den Segmented-Picker)
            VStack(alignment: .leading, spacing: 8) {
                HStack() {
                    Text("Bereich")
                        .font(.caption)
                        .foregroundStyle(.white)
                    Spacer()
                }
                
                Picker("Bereich", selection: $quoteVM.selectedDomain) {
                    ForEach(LifeDomain.allCases, id: \.self) { domain in
                        Text(domain.displayName).tag(domain)
                    }
                }
                .pickerStyle(.segmented)
                .tint(.white) // Segment-Farbe auf Ihren Hintergrund abstimmen
                .padding(6)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(.white.opacity(0.18), lineWidth: 0.5)
                )
                .shadow(color: .black.opacity(0.25), radius: 10, y: 3)
                .onChange(of: quoteVM.selectedDomain) { _, newDomain in
                    quoteVM.updateDomain(newDomain)
                }
            }
           .frame(width: 330)
        }
    }
    
    @ViewBuilder
    var mainContentSection: some View {
        if quoteVM.isLoading {
            // Loading State
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.2)
                Text("Zitat wird geladen...")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, minHeight: 200)
            
        } else if let quote = quoteVM.currentQuote {
            // Quote anzeigen
            QuoteCard(
                quote: quote,
                dataManager: dataManager,
                quoteService: quoteService,
                config: .init(showCategoryBadge: true, showActions: true),
                backgroundStyle: .categoryGradient(quote.category)
            )
            .padding(.horizontal)
            .onReceive(NotificationCenter.default.publisher(for: .init("QuoteRefreshed"))) { notification in
                if let newQuote = notification.object as? Quote {
                    quoteVM.currentQuote = newQuote
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .init("FavoriteChanged"))) { notification in
                if let userInfo = notification.userInfo,
                   let isFavorited = userInfo["isFavorited"] as? Bool {
                    quoteVM.isFavorited = isFavorited
                }
            }
            
        } else {
            // Empty State
            ContentUnavailableView(
                "Kein Zitat verfügbar",
                systemImage: "quote.bubble",
                description: Text("Tippen Sie auf 'Neues Zitat' um zu beginnen.")
            )
            .frame(maxWidth: .infinity, minHeight: 200)
        }
    }
    
    @ViewBuilder
    var errorSection: some View {
        if let errorMessage = quoteVM.errorMessage {
            HStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.red)
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
                Spacer()
                Button("Dismiss") {
                    Task {
                        await quoteVM.clearError()
                    }
                }
                .font(.caption)
                .buttonStyle(.bordered)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.red.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.top, 4)
        }
    }
}

// MARK: - Preview
#Preview {
    let container = SwiftDataConfigurator.createPreviewContainer()
    let dm = DataManager(modelContext: container.mainContext)
    let quoteVM = QuoteViewModel(dataManager: dm)
    
    quoteVM.currentQuote = Quote(
        text: "Vorschau-Zitat für die optimierte ContentView mit vollständiger ViewModel-Integration.",
        author: "Preview Author",
        category: .motivation
    )
    quoteVM.isFavorited = false
    
    return ContentView()
        .environmentObject(quoteVM)
        .modelContainer(container)
}
