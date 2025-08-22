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
        ZStack {
        //   AppBackground2()
          //  .frame(width: 300)
                
            HStack(spacing: 12) {
                // Kategorie Icon
                Image(category.icon)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(4)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
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
                    .background(Color.orange)
                    .clipShape(Capsule())
            }
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    CategoryHeaderView(category: .motivation, count: 5)
        .padding()
}
