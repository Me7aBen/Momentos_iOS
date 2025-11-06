//
//  BadgeManager.swift
//  Momentos
//
//  Created by Brian Benjamin Pareja Meruvia on 5/11/25.
//

import Foundation
    import SwiftData

    class BadgeManager {
        private let modelContainer: ModelContainer

        init(modelContainer: ModelContainer) {
            self.modelContainer = modelContainer
        }

        /// Revisa todos los logros bloqueados y los desbloquea si se cumplen
        /// las condiciones. Se llama CADA VEZ que se guarda un nuevo momento.
        func unlockBadges(newMoment: Moment) throws {
            let context = modelContainer.mainContext
            
            // 1. Obtenemos TODOS los momentos (incluyendo el nuevo)
            let moments = try context.fetch(FetchDescriptor<Moment>())
            
            // 2. Obtenemos solo los logros bloqueados (timestamp == nil)
            let lockedBadges = try context.fetch(FetchDescriptor<Badge>(predicate: #Predicate { $0.timestamp == nil }))

            var newlyUnlocked: [Badge] = []
            
            // 3. Iteramos sobre los logros bloqueados para ver si alguno se desbloquea
            for badge in lockedBadges {
                switch badge.details {
                case .firstEntry where moments.count >= 1:
                    newlyUnlocked.append(badge)
                    
                case .fiveStars where moments.count >= 5:
                    newlyUnlocked.append(badge)
                    
                case .shutterbug where moments.count(where: { $0.image != nil }) >= 3:
                    newlyUnlocked.append(badge)
                    
                case .expressive where moments.count(where: { $0.image != nil && !$0.note.isEmpty }) >= 5:
                    newlyUnlocked.append(badge)
                    
                // ".perfectTen" requiere que todos los otros 4 logros ya estén desbloqueados.
                // Si `lockedBadges.count` es 1, significa que este es el último.
                case .perfectTen where moments.count >= 10 && lockedBadges.count == 1:
                    newlyUnlocked.append(badge)
                    
                default:
                    continue
                }
            }

            // 4. Marcamos los nuevos logros como desbloqueados
            for badge in newlyUnlocked {
                badge.moment = newMoment
                badge.timestamp = newMoment.timestamp
            }
        }

        /// Carga todas las "plantillas" de logros en la base de datos
        /// la primera vez que se abre la app.
        func loadBadgesIfNeeded() throws {
            let context = modelContainer.mainContext
            var fetchDescriptor = FetchDescriptor<Badge>()
            fetchDescriptor.fetchLimit = 1 // Solo necesitamos saber si hay al menos 1
            
            let existingBadges = try context.fetch(fetchDescriptor)
            
            // Si no hay ninguno, los creamos todos
            if existingBadges.isEmpty {
                for details in BadgeDetails.allCases {
                    context.insert(Badge(details: details))
                }
            }
        }
    }
