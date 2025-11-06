//
//  AchievementsView.swift
//  Momentos
//
//  Created by Brian Benjamin Pareja Meruvia on 5/11/25.
//

import SwiftUI
    import SwiftData

    struct AchievementsView: View {
        // --- Consultas (Queries) Filtradas ---
        
        // Pide a SwiftData solo los logros DESBLOQUEADOS (timestamp no es nil)
        @Query(filter: #Predicate<Badge> { $0.timestamp != nil })
        private var unlockedBadges: [Badge]

        // Pide solo los logros BLOQUEADOS (timestamp es nil)
        @Query(filter: #Predicate<Badge> { $0.timestamp == nil })
        private var lockedBadges: [Badge]

        // Pide TODOS los momentos (para calcular la racha)
        @Query(sort: \Moment.timestamp)
        private var moments: [Moment]

        var body: some View {
            NavigationStack {
                ScrollView {
                    contentStack
                }
                .navigationTitle("Logros")
            }
            .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
        }

        private var contentStack: some View {
            VStack(alignment: .leading) {
                // 1. Vista de Racha
                StreakView(numberOfDays: StreakCalculator().calculateStreak(for: moments))
                    .frame(maxWidth: .infinity)
                
                // 2. Sección de Logros Desbloqueados
                if !unlockedBadges.isEmpty {
                    header("Tus Logros")
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(sortedUnlockedBadges) { badge in
                                UnlockedBadgeView(badge: badge)
                            }
                        }
                    }
                    .scrollClipDisabled()
                    .scrollIndicators(.hidden)
                }
                
                // 3. Sección de Logros Bloqueados
                if !lockedBadges.isEmpty {
                    header("Logros Bloqueados")
                    ForEach(sortedLockedBadges) { badge in
                        LockedBadgeView(badge: badge)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
        }

        // Pequeña vista de ayuda para los títulos de sección
        func header(_ text: String) -> some View {
            Text(text)
                .font(.subheadline.bold())
                .padding(.horizontal)
        }

        // Ordena los logros desbloqueados por fecha
        private var sortedUnlockedBadges: [Badge] {
            unlockedBadges.sorted {
                ($0.timestamp!, $0.details.title) < ($1.timestamp!, $1.details.title)
            }
        }

        // Ordena los logros bloqueados por su ID interno (Int)
        private var sortedLockedBadges: [Badge] {
            lockedBadges.sorted {
                $0.details.rawValue < $1.details.rawValue
            }
        }
    }

    #Preview {
        AchievementsView()
            .sampleDataContainer()
    }
