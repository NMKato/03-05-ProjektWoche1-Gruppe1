//
//  LaunchScreenView.swift
//  Projektwoche1
//
//  Created by Nikolas Kato on 20.08.25.
//  Bereinigt: Unbenutzte Code-Bereiche entfernt

import SwiftUI

struct LaunchScreenView: View {
    
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0.0
    @State private var progressValue: Double = 0.0
    @State private var versionOpacity: Double = 0.0
    
    @Binding var isLaunchComplete: Bool
    
    var body: some View {
        ZStack {
            
            AppBackground()
            // Background mit launchscreen01 Bild
            Image("launchscreen01")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.container, edges: [.top, .bottom])
            
            VStack(spacing: 40) {
                Spacer()
                
                // Logo Section
                VStack(spacing: 24) {
                    // Mascotchen Logo
                    Image("LaunchScreen01")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
                    
                    // Slogan Text
                    Text("Stimmung rein. Zitat raus..")
                        .font(.system(size: 22, weight: .medium, design: .rounded))
                        .foregroundColor(Color(.black))
                        .multilineTextAlignment(.center)
                        .opacity(logoOpacity)
                        .scaleEffect(logoScale * 0.98)
                        .shadow(color: Color(.black).opacity(0.3), radius: 3, x: 0, y: 2)
                }
                
                Spacer()
                
                // Loading Section
                VStack(spacing: 20) {
                    // Progress Bar
                    ZStack(alignment: .leading) {
                        // Background Bar
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 280, height: 8)
                        
                        // Progress Bar
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [Color(.black), Color(.black).opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 280 * progressValue, height: 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.black, lineWidth: 0.5)
                                    .frame(width: 280 * progressValue, height: 8)
                            )
                            .animation(.easeInOut(duration: 0.3), value: progressValue)
                    }
                    .opacity(logoOpacity)
                    
                    // Loading Text
                    Text("Wird geladen...")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                        .opacity(logoOpacity)
                }
                
                Spacer()
                
                // Version Info
                VStack(spacing: 8) {
                    Text("Version 1.0.0")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                        .opacity(versionOpacity)
                    
                    Text("© 2025 Quote Craft")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.black.opacity(0.7))
                        .opacity(versionOpacity)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            startLaunchSequence()
        }
    }
    
    // MARK: - Launch Animation Sequence
    
    private func startLaunchSequence() {
        // Phase 1: Logo Animation (0.5s)
        withAnimation(.easeOut(duration: 0.5)) {
            logoOpacity = 1.0
            logoScale = 1.0
        }
        
        // Phase 2: Version Info (1.0s delay)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 0.4)) {
                versionOpacity = 1.0
            }
        }
        
        // Phase 3: Progress Animation (1.5s delay)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            simulateLoading()
        }
        
        // Phase 4: Complete after 4 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            completeLaunch()
        }
    }
    
    private func simulateLoading() {
        let loadingSteps: [Double] = [0.2, 0.4, 0.6, 0.8, 0.9, 1.0]
        
        for (index, step) in loadingSteps.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.25) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    progressValue = step
                }
            }
        }
    }
    
    private func completeLaunch() {
        withAnimation(.easeInOut(duration: 0.3)) {
            logoOpacity = 0.0
            versionOpacity = 0.0
        }
        
        // Complete launch after fade animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isLaunchComplete = true
        }
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var isComplete = false
    
    LaunchScreenView(isLaunchComplete: $isComplete)
}
