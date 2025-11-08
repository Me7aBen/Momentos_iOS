//
//  StreakView.swift
//  Momentos
//
//  Created by Brian Benjamin Pareja Meruvia on 5/11/25.
//

import SwiftUI

    struct StreakView: View {
        var numberOfDays: Int

        var body: some View {
            // Reutilizamos nuestro Hexagon, pero con borde secundario
            Hexagon(borderColor: .secondary) {
                VStack(spacing: 0) {
                    Text("Racha \(Image(systemName: "flame.fill"))")
                        .foregroundStyle(.ember)
                    // attributedText nos permite poner "10" en grande y "Días" en pequeño
                    Text(attributedText)
                        .multilineTextAlignment(.center)
                }
                .font(.callout)
            }
        }

        // Esta propiedad combina dos tamaños de fuente en un solo texto
        var attributedText: AttributedString {
            var attributedString = AttributedString(localized: "^[\(numberOfDays) \nDías](inflect: true)")
            if let range = attributedString.range(of: "\(numberOfDays)") {
                attributedString[range].font = .system(size: 70)
            }
            return attributedString
        }
    }

    #Preview {
        StreakView(numberOfDays: 10)
    }
