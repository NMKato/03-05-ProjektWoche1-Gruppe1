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
        
       
       //   AppBackground()
              
        
            TabView {
                
                ContentView()
                
                    .tabItem {
                        Image(systemName: "house")
                        Text("Start")
                    }
                
            }
            .frame(width:405)
           
            
              
                }
           
        }
    

// gemeinsemerPreviewContainer
#Preview {
    let container = SwiftDataConfigurator.createPreviewContainer()
    let dm = DataManager(modelContext: container.mainContext)
    // quote fm für viewmodel + beispiel quote
    let quoteVM = QuoteViewModel(dataManager: dm)
    
    quoteVM.currentQuote = Quote(
        text: "Vorschau Zitat für TabView",
        author: "Preview Author",
        category: .motivation)
    
    
    
    // Platzhalter für favoriteViewModel
    let favVM = FavoritesViewModel(dataManager: dm)
    if let q = quoteVM.currentQuote {
        try? dm.addToFavorites(q)
        Task { await favVM.loadFavorites() }
    }
        return MainTabView()
            .environmentObject(quoteVM)
            .environmentObject(favVM)
            .modelContainer(container)
        
   
    
    
}
