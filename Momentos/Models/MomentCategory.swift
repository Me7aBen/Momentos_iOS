import Foundation
import SwiftUI

/// Categorías estáticas para los Momentos (MVVM-friendly)
/// Fuente única de verdad para nombres, íconos y listados.
enum MomentCategory: String, CaseIterable, Identifiable, Sendable {
    case familia = "Familia"
    case comida = "Comida"
    case viajes = "Viajes"
    case estudios = "Estudios"
    case trabajo = "Trabajo"
    case salud = "Salud"
    case amigos = "Amigos"
    case otros = "Otros"

    static let `default`: MomentCategory = .familia

    var id: String { rawValue }

    var displayName: String { rawValue }

    /// Ícono sugerido del SF Symbols (opcional para UI)
    var iconName: String {
        switch self {
        case .familia: return "person.3.fill"
        case .comida: return "fork.knife"
        case .viajes: return "airplane"
        case .estudios: return "book.fill"
        case .trabajo: return "briefcase.fill"
        case .salud: return "heart.fill"
        case .amigos: return "person.2.fill"
        case .otros: return "tag.fill"
        }
    }
}
