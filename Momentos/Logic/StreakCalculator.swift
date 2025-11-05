//
//  StreakCalculator.swift
//  Momentos
//
//  Created by Brian Benjamin Pareja Meruvia on 5/11/25.
//

import Foundation

    struct StreakCalculator {
        let calendar = Calendar.current

        /// Cuenta el número de días seguidos que se ha guardado un momento.
        /// - precondition: `moments` debe estar ordenado por timestamp, del más antiguo al más nuevo.
        func calculateStreak(for moments: [Moment]) -> Int {
            let startOfToday = calendar.startOfDay(for: .now)
            // Obtenemos el final del día de hoy (ej. hoy a las 23:59:59)
            let endOfToday = calendar.date(byAdding: DateComponents(day: 1, second: -1), to: startOfToday)!

            // 1. Damos vuelta al array (de más nuevo a más antiguo)
            // 2. Obtenemos solo los timestamps
            // 3. Calculamos cuántos días "atrás" (0 = hoy, 1 = ayer) fue cada momento
            // 4. Filtramos los nil (compactMap)
            // Ej. resultado: [0, 0, 1, 2, 4, 5] (hubo 2 hoy, 1 ayer, 1 anteayer, 1 hace 4 días...)
            let daysAgoArray = moments
                .reversed()
                .map(\.timestamp)
                .map { calendar.dateComponents([.day], from: $0, to: endOfToday) }
                .compactMap { $0.day }

            var streak = 0
            
            // Si el último momento no fue hoy (0) o ayer (1), la racha es 0.
            if let lastDay = daysAgoArray.first, lastDay > 1 {
                return 0
            }

            // Un Set nos da los días únicos (ej. [0, 1, 2, 4, 5])
            let uniqueDays = Set(daysAgoArray)

            // Contamos desde hoy (0) hacia atrás
            while uniqueDays.contains(streak) {
                streak += 1
            }

            return streak
        }
    }
