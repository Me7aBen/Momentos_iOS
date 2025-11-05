//
//  Moment.swift
//  Momentos
//
//  Created by Brian Benjamin Pareja Meruvia on 5/11/25.
//
import Foundation
    import SwiftData
    import UIKit

    // @Model es la macro mágica de SwiftData.
    // Automáticamente hace que esta clase sea almacenable en la base de datos.
    @Model
    class Moment {
        var title: String
        var note: String
        var imageData: Data? // Guardamos la imagen como Data (binario)
        var timestamp: Date
        
        // Relación: Un momento puede desbloquear varias insignias.
        // Lo usaremos en la próxima sesión.
        //@Relationship(inverse: \Badge.moment)
        //var badges: [Badge] = []

        init(title: String, note: String, imageData: Data? = nil, timestamp: Date = .now) {
            self.title = title
            self.note = note
            self.imageData = imageData
            self.timestamp = timestamp
        }

        // Una 'propiedad computada' conveniente para convertir los Data
        // en un objeto UIImage que la app pueda mostrar.
        var image: UIImage? {
            imageData.flatMap {
                UIImage(data: $0)
            }
        }
    }

    // Extensión para proveer datos de muestra para nuestras Vistas Previas (Previews)
    extension Moment {
        static let sample = sampleData[0]
        static let longTextSample = sampleData[1]
        static let imageSample = sampleData[4]

        // --- DATOS DE MUESTRA TRADUCIDOS ---
        static let sampleData = [
            Moment(
                title: "🍅🥳",
                note: "¡Recolecté mi primer tomate de la huerta!"
            ),
            Moment(
                title: "¡Aprobé el examen!",
                note: "El examen de química estuvo difícil, pero creo que me fue bien 🙌. Qué bueno que contacté a Guillermo y Lee para estudiar. ¡Realmente ayudó!",
                imageData: UIImage(named: "Study")?.pngData()
            ),
            Moment(
                title: "Tiempo de descanso",
                note: "Muy agradecido por una tarde relajante después de una semana ocupada.",
                imageData: UIImage(named: "Relax")?.pngData()
            ),
            Moment(
                title: "Familia ❤️",
                note: ""
            ),
            Moment(
                title: "¡Genial!",
                note: "Fui a un gran concierto con Blair 🎶",
                imageData: UIImage(named: "Concert")?.pngData()
            )
        ]
    }
