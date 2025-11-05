//
//  MomentosApp.swift
//  Momentos
//
//  Created by Brian Benjamin Pareja Meruvia on 5/11/25.
//

import SwiftUI
import SwiftData

@main
struct MomentosApp: App {
    
    // Crea una instancia de nuestro DataContainer.
            // 'includeSampleMoments' es falso por defecto,
            // así que esto creará una base de datos real en el dispositivo.
            let dataContainer = DataContainer()

            var body: some Scene {
                WindowGroup {
                    ContentView()
                        // Inyecta el DataContainer en el entorno de SwiftUI
                        .environment(dataContainer)
                }
                // Proporciona el ModelContainer de SwiftData a toda la app
                .modelContainer(dataContainer.modelContainer)
            }
}
