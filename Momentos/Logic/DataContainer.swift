//
//  DataContainer.swift
//  Momentos
//
//  Created by Brian Benjamin Pareja Meruvia on 5/11/25.
//

import SwiftData
    import SwiftUI

    // @Observable hace que esta clase pueda ser observada por las vistas de SwiftUI.
    @Observable
    @MainActor // Asegura que se ejecute en el hilo principal (importante para UI)
    class DataContainer {
        let modelContainer: ModelContainer
        
        // 'badgeManager' lo añadiremos en la próxima sesión.
         var badgeManager: BadgeManager

        var context: ModelContext {
            modelContainer.mainContext
        }

        init(includeSampleMoments: Bool = false) {
            // 1. Define el 'esquema' o la forma de la base de datos.
            // Por ahora, solo guardará objetos 'Moment'.
            let schema = Schema([
                Moment.self,
                Badge.self // Añadimos Badge aquí para prepararnos para la Sesión 3
            ])

            // 2. Configura cómo se guardarán los datos.
            // 'isStoredInMemoryOnly: true' es CLAVE para las vistas previas.
            // Significa que la base de datos vive solo en la memoria y se borra
            // cada vez que la app se reinicia. Perfecto para pruebas.
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: includeSampleMoments)

            do {
                // 3. Intenta crear el contenedor.
                modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
                
                badgeManager = BadgeManager(modelContainer: modelContainer)
                try badgeManager.loadBadgesIfNeeded() // Carga los logros al iniciar

                // 4. Si 'includeSampleMoments' es verdadero, carga los datos de muestra.
                if includeSampleMoments {
                    try loadSampleMoments()
                }
                try context.save()
            } catch {
                // Mensaje de error traducido
                fatalError("No se pudo crear el ModelContainer: \(error)")
            }
        }

        private func loadSampleMoments() throws {
            for moment in Moment.sampleData {
                context.insert(moment)
                 try badgeManager.unlockBadges(newMoment: moment)
            }
        }
    }

    // --- Extensión de View para Vistas Previas ---
    // Este es un truco genial. Creamos un 'DataContainer' estático
    // solo para nuestras vistas previas.
    private let sampleContainer = DataContainer(includeSampleMoments: true)

    // Añadimos una función a TODAS las Vistas (View) en nuestra app
    // que nos permite inyectar fácilmente los datos de muestra.
    extension View {
        func sampleDataContainer() -> some View {
            self
                .environment(sampleContainer)
                .modelContainer(sampleContainer.modelContainer)
        }
    }
