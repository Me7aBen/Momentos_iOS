//
//  StreakCalculator.swift
//  Momentos
//
//  Created by Brian Benjamin Pareja Meruvia on 5/11/25.
//
import Foundation

struct StreakCalculator {
    let calendar = Calendar.current

    func calculateStreak(for moments: [Moment]) -> Int {
        // Ordena los momentos del más nuevo al más antiguo
        let sortedMoments = moments.sorted(by: { $0.timestamp > $1.timestamp })
        
        // Mapea los momentos a los días en que ocurrieron (ignorando la hora)
        let dates = sortedMoments.map { calendar.startOfDay(for: $0.timestamp) }
        
        // Elimina duplicados (si se registraron 2 momentos el mismo día)
        let uniqueDates = dates.reduce(into: [Date]()) { result, date in
            if result.last != date {
                result.append(date)
            }
        }
        
        if uniqueDates.isEmpty {
            return 0
        }
        
        var streak = 0
        let today = calendar.startOfDay(for: .now)
        
        // Revisa si la última entrada fue hoy o ayer
        if uniqueDates.first == today {
            streak = 1
        } else if uniqueDates.first == calendar.date(byAdding: .day, value: -1, to: today) {
            streak = 1 // Si fue ayer, la racha "sigue viva" y contamos desde ayer
        } else {
            return 0 // Si fue antes de ayer, la racha se rompió
        }

        // Si hay más de una fecha única, contamos hacia atrás
        guard uniqueDates.count > 1 else {
            return streak
        }

        // Comparamos cada día con el día anterior
        for (index, date) in uniqueDates.enumerated() {
            // Saltamos el primer día (ya lo contamos)
            if index == 0 { continue }
            
            let previousDate = uniqueDates[index - 1]
            let expectedDate = calendar.date(byAdding: .day, value: -1, to: previousDate)
            
            if date == expectedDate {
                streak += 1 // El día es consecutivo, suma la racha
            } else {
                break // El día no es consecutivo, rompe el bucle
            }
        }
        
        return streak
    }
}
