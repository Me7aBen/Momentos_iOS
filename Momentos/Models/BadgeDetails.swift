//
//  BadgeDetails.swift
//  Momentos
//
//  Created by Brian Benjamin Pareja Meruvia on 5/11/25.
//

import Foundation
    import SwiftUI

    // Este enum define la "plantilla" estática para cada logro posible.
    // No se guarda en la base de datos, es solo información de la app.
    enum BadgeDetails: Int, Codable, CaseIterable {
        case firstEntry
        case fiveStars
        case shutterbug
        case expressive
        case perfectTen

        // Requisitos (texto que ve el usuario)
        var requirements: String {
            switch self {
            case .firstEntry:
                return "Registra un momento para empezar tu viaje."
            case .fiveStars:
                return "Registra cinco momentos."
            case .shutterbug:
                return "Añade tres entradas con fotos."
            case .expressive:
                return "Añade cinco momentos con foto y texto."
            case .perfectTen:
                return "Registra al menos 10 momentos, coleccionando todas las otras insignias."
            }
        }

        // Título del logro
        var title: String {
            switch self {
            case .firstEntry:
                return "Comienza el Viaje"
            case .fiveStars:
                return "5 Estrellas"
            case .shutterbug:
                return "Fotógrafo"
            case .expressive:
                return "Expresivo"
            case .perfectTen:
                return "10 Perfecto"
            }
        }

        // Nombre de la imagen desbloqueada (de Assets.xcassets)
        var image: ImageResource {
            switch self {
            case .firstEntry:
                return .firstEntryUnlocked
            case .fiveStars:
                return .fiveStarsUnlocked
            case .shutterbug:
                return .shutterbugUnlocked
            case .expressive:
                return .expressiveUnlocked
            case .perfectTen:
                return .perfectTenUnlocked
            }
        }

        // Nombre de la imagen bloqueada (de Assets.xcassets)
        var lockedImage: ImageResource {
            switch self {
            case .firstEntry:
                return .firstEntryLocked
            case .fiveStars:
                return .fiveStarsLocked
            case .shutterbug:
                return .shutterbugLocked
            case .expressive:
                return .expressiveLocked
            case .perfectTen:
                return .perfectTenLocked
            }
        }

        // Color asociado
        var color: Color {
            switch self {
            case .firstEntry:
                return .ember
            case .fiveStars:
                return .ruby
            case .shutterbug:
                return .sapphire
            case .expressive:
                return .ocean
            case .perfectTen:
                return .ember
            }
        }

        // Mensaje de felicitación
        var congratulatoryMessage: String {
            switch self {
            case .firstEntry:
                return "Todo viaje comienza con un solo paso. ¡Felicidades, estás en camino!"
            case .fiveStars:
                return "¡Estás tomando impulso! Mientras más te enfocas en la práctica regular, mejor te vuelves."
            case .shutterbug:
                return "Las fotos nos conectan con nuestro pasado y nos transportan a ese sentimiento de gratitud."
            case .expressive:
                return "¡Mírate! Dándote todas las formas de saborear tus recuerdos felices."
            case .perfectTen:
                return "¡Le estás agarrando el truco a tu nuevo hábito! Sigue así y mira qué tan lejos puedes llegar."
            }
        }
    }
