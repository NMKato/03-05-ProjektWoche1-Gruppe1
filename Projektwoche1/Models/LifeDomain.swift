//
//  LifeDomain.swift
//  Projektwoche1
//
//  Created by Nikolas Kato on 20.08.25.
//

import Foundation


import Foundation

/// Lebensbereich / Kontext der aktuellen Situation
enum LifeDomain: String, CaseIterable, Codable, Sendable {
    case work = "Arbeit"
    case leisure = "Freizeit"
    case privateLife = "Privat"

    var displayName: String { rawValue }
}
