//
//  Badge.swift
//  Momentos
//
//  Created by Brian Benjamin Pareja Meruvia on 5/11/25.
//
import Foundation
    import SwiftData

    /// Representa una instancia de un logro desbloqueado por el usuario.
    /// Usamos `timestamp` para saber si un logro está desbloqueado (si no es nil).
    @Model
    class Badge {
        // Guarda la 'plantilla' del logro (ej. .firstEntry)
        var details: BadgeDetails
        
        // El momento específico que desbloqueó este logro
        var moment: Moment?
        
        // La fecha en que se desbloqueó. Si es 'nil', está bloqueado.
        var timestamp: Date?

        init(details: BadgeDetails) {
            self.details = details
            self.moment = nil
            self.timestamp = nil
        }
    }

    // Datos de muestra para vistas previas
    extension Badge {
        static var sample: Badge {
            let badge = Badge(details: .firstEntry)
            badge.timestamp = .now
            badge.moment = .sample
            return badge
        }
    }
