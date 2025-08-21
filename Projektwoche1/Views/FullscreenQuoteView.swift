//
//  FullscreenQuoteView.swift
//  Projektwoche1
//
//  Created by Nikolas Kato on 21.08.25.
//

import SwiftUI

struct FullscreenQuoteView: View {
    let quote: Quote
    let dataManager: DataManager
    @Environment(\.dismiss) private var dismiss
    @State private var showShareSheet = false
    
    var body: some View {
        ZStack {
            // Hintergrund
         //   AppBackground2()
            Image("favBack01")
                  .frame(width: 360, height: 200)
                   
                LinearGradient(
                colors: gradientColors(for: quote.category),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            
            
            
            // Content
            VStack(spacing: 20) {
                // Top Bar
                HStack {
                    Button("Fertig") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                    .font(.headline)
                    
                    Spacer()
                    
                    Button {
                        showShareSheet = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title2)
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Spacer()
                
                // Quote Content
                VStack(spacing: 24) {
                    Text(quote.text)
                        .font(.title.weight(.medium))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 32)
                    
                    Text("- \(quote.author) -")
                        .font(.title3)
                        .foregroundStyle(.white.opacity(0.8))
                }
                
                
                Spacer()
            }
            
            // BodenBild (gleich wie in QuoteCard)
                VStack {
                    Spacer()
                    Image("blaetterBoden03")
                        .resizable()
                        
                        .scaledToFill()
                        .ignoresSafeArea()
                        .frame(width: 360, height: 200)
                        
                        .opacity(0.6)
                }
                .allowsHitTesting(false)
            
        }
        
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(content: shareText)
        }
        
    }
    
    
    private var shareText: String {
        """
        "\(quote.text)"
        
        - \(quote.author) -
        
        Geteilt via QuoteCraft
        """
    }
    
    private func gradientColors(for category: Category?) -> [Color] {
        switch category {
        case .motivation:
            return [Color.orange.opacity(0.8), Color.red.opacity(0.6)]
        case .wisdom:
            return [Color.blue.opacity(0.8), Color.indigo.opacity(0.6)]
        case .programming:
            return [Color.green.opacity(0.8), Color.teal.opacity(0.6)]
        case .general:
            return [Color.gray.opacity(0.6), Color.gray.opacity(0.8)]
        case .drinking:
            return [Color.yellow.opacity(0.8), Color.orange.opacity(0.6)]
        case .mindset:
            return [Color.purple.opacity(0.8), Color.blue.opacity(0.6)]
        case .none:
            return [Color.gray.opacity(0.6), Color.gray.opacity(0.8)]
        }
    }
}

// MARK: - ShareSheet Helper
private struct ShareSheet: UIViewControllerRepresentable {
    let content: String
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityVC = UIActivityViewController(
            activityItems: [content],
            applicationActivities: nil
        )
        return activityVC
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Keine Updates benötigt
    }
}

#Preview {
    FullscreenQuoteView(
        quote: Quote(text: "Preview Quote für die korrigierte Vollbild-Ansicht.", author: "Preview Author", category: .motivation),
        dataManager: DataManager(modelContext: SwiftDataConfigurator.createPreviewContainer().mainContext)
    )
}
