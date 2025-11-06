//
//  ContentView.swift
//  Momentos
//
//  Created by Brian Benjamin Pareja Meruvia on 5/11/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // TabView es el componente que crea la barra de pestañas inferior
        TabView {
            // --- Pestaña 1 ---
            MomentsView()
                .tabItem {
                    Label("Momentos", image: "MomentsTab") // Icono personalizado
                }
            
            // --- Pestaña 2 ---
            AchievementsView()
                .tabItem {
                    Label("Logros", systemImage: "medal.fill") // Icono del sistema
                }
        }
    }
}

#Preview {
    ContentView()
        .sampleDataContainer()
}
