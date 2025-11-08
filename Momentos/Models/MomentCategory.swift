// Momentos/Models/MomentCategory.swift

import SwiftUI

enum MomentCategory: Int, Codable, CaseIterable, Identifiable {
    case familia
    case amigos
    case trabajo
    case estudio
    case hobby
    case viaje
    case naturaleza
    case comida
    case salud
    case otro

    var id: Self { self }

    var title: String {
        switch self {
        case .familia: return "Familia"
        case .amigos: return "Amigos"
        case .trabajo: return "Trabajo"
        case .estudio: return "Estudio"
        case .hobby: return "Hobby"
        case .viaje: return "Viaje"
        case .naturaleza: return "Naturaleza"
        case .comida: return "Comida"
        case .salud: return "Salud"
        case .otro: return "Otro"
        }
    }
    
    var systemImage: String {
        switch self {
        case .familia: return "heart.fill"
        case .amigos: return "person.2.fill"
        case .trabajo: return "briefcase.fill"
        case .estudio: return "book.fill"
        case .hobby: return "paintbrush.fill"
        case .viaje: return "airplane"
        case .naturaleza: return "leaf.fill"
        case .comida: return "fork.knife"
        case .salud: return "figure.walk"
        case .otro: return "ellipsis.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .familia: return .red
        case .amigos: return .orange
        case .trabajo: return .blue
        case .estudio: return .indigo
        case .hobby: return .purple
        case .viaje: return .cyan
        case .naturaleza: return .green
        case .comida: return .yellow
        case .salud: return .mint
        case .otro: return .gray
        }
    }
}
