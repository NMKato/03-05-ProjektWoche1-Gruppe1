import SwiftUI

struct InfoView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("MUSE")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                Text("Diese App soll dir schöne Motivation schenken.")
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text("Wichtiger Hinweis: Diese App dient der Unterhaltung. Die Entwickler übernehmen keine Haftung für Entscheidungen basierend auf den bereitgestellten Zitaten.")
                    .font(.callout)
                    .foregroundStyle(.black.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
            }
            .padding()
            .background { AppBackground() }
            .navigationTitle("Info")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fertig") {
                        dismiss()
                    }
                    .foregroundColor(.yellow)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    InfoView()
}
