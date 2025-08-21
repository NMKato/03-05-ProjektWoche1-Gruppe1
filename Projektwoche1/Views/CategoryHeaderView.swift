//
//  CategoryHeaderView.swift
//  Projektwoche1
//
//  Created by Nikolas Kato on 21.08.25.
//

import SwiftUI

struct CategoryHeaderView: View {
    let category: Category
    let count: Int
    
    var body: some View {
        HStack(spacing: 12) {
            // Kategorie Icon
            Text(category.icon)
                .font(.title2)
            
            // Kategorie Name
            Text(category.displayName)
                .font(.headline)
                .foregroundStyle(.primary)
            
            Spacer()
            
            // Anzahl Badge
            Text("\(count)")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.accentColor)
                .clipShape(Capsule())
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    CategoryHeaderView(category: .motivation, count: 5)
        .padding()
}
