// Momentos/Models/Moment.swift

import Foundation
import SwiftData
import UIKit

@Model
class Moment {
    var title: String
    var note: String
    var imageData: Data?
    var timestamp: Date
    var category: MomentCategory // <-- AÑADIDO

    @Relationship(inverse: \Badge.moment)
    var badges: [Badge] = []

    // Actualiza el 'init'
    init(title: String, note: String, imageData: Data? = nil, timestamp: Date = .now, category: MomentCategory = .otro) {
        self.title = title
        self.note = note
        self.imageData = imageData
        self.timestamp = timestamp
        self.category = category // <-- AÑADIDO
    }

    var image: UIImage? {
        imageData.flatMap {
            UIImage(data: $0)
        }
    }
}

extension Moment {
    static let sample = sampleData[0]
    static let longTextSample = sampleData[1]
    static let imageSample = sampleData[4]

    // Actualiza los datos de muestra
    static let sampleData = [
        Moment(
            title: "🍅🥳",
            note: "¡Recolecté mi primer tomate de la huerta!",
            category: .naturaleza // <-- AÑADIDO
        ),
        Moment(
            title: "¡Aprobé el examen!",
            note: "El examen de química estuvo difícil, pero creo que me fue bien 🙌. Qué bueno que contacté a Guillermo y Lee para estudiar. ¡Realmente ayudó!",
            imageData: UIImage(named: "Study")?.pngData(),
            category: .estudio // <-- AÑADIDO
        ),
        Moment(
            title: "Tiempo de descanso",
            note: "Muy agradecido por una tarde relajante después de una semana ocupada.",
            imageData: UIImage(named: "Relax")?.pngData(),
            category: .salud // <-- AÑADIDO
        ),
        Moment(
            title: "Familia ❤️",
            note: "",
            category: .familia // <-- AÑADIDO
        ),
        Moment(
            title: "¡Genial!",
            note: "Fui a un gran concierto con Blair 🎶",
            imageData: UIImage(named: "Concert")?.pngData(),
            category: .amigos // <-- AÑADIDO
        )
    ]
}
