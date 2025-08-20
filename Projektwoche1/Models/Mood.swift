//
//  Mood.swift
//  Projektwoche1
//
//  Created by Nikolas Kato on 20.08.25.
//

import Foundation


import Foundation

/// Stimmungslage des Nutzers (für passende Zitat-Auswahl)
enum Mood: String, CaseIterable, Codable, Sendable {
    case freude = "Freude"
    case traurig = "Traurig"
    case unsicher = "Unsicher"
    case enttaeuscht = "Enttäuscht"

    var displayName: String { rawValue }
}



