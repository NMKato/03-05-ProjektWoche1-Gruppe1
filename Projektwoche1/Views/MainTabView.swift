//
//  MainTabView.swift
//  Projektwoche1
//
//  Created by Florica Girisci on 19.08.25.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    
    var body: some View {
        
        TabView {
            ContentView()
                .tabItem {
               //     Image(systemName: "house")
                //    Text("Start")
                }
            
        }
       
    }
        
}

// Preview
#Preview {
    let container = SwiftDataConfigurator.createPreviewContainer()
    let dm = DataManager(modelContext: container.mainContext)
    let quoteVM = QuoteViewModel(dataManager: dm)
    
    quoteVM.currentQuote = Quote(
        text: "Vorschau Zitat für TabView",
        author: "Preview Author",
        category: .motivation
    )
    
    return MainTabView()
        .environmentObject(quoteVM)
        .modelContainer(container)
}
