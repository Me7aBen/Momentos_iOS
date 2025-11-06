//
//  HexagonAccessoryView.swift
//  Momentos
//
//  Created by Brian Benjamin Pareja Meruvia on 5/11/25.
//

import SwiftUI

    struct HexagonAccessoryView: View {
        let moment: Moment
        let hexagonLayout: HexagonLayout
        
        var body: some View {
            // Es un link de navegación
            NavigationLink {
                // Si solo hay 1 logro, va directo al detalle del logro
                if badges.count == 1 {
                    BadgeDetailView(badge: badges[0])
                } else {
                    // Si hay +1, va al detalle del momento (donde se listan todos)
                    MomentDetailView(moment: moment)
                }
            } label: {
                badgeView
            }
        }

        private var badgeView: some View {
            Group {
                if badges.count > 1 {
                    // Muestra "+N" (ej. "+2")
                    Text("+\(badges.count)")
                        .bold()
                        .minimumScaleFactor(0.3)
                        .frame(width: size * 0.5, height: size * 0.5)
                        .padding(8)
                        .background {
                            Image("Blank") // Imagen en blanco
                                .resizable()
                                .frame(width: size, height: size)
                                .shadow(radius: 2)
                        }
                        .foregroundStyle(.gray)
                } else if let badge = badges.first {
                    // Muestra la imagen del logro
                    Image(badge.details.image)
                        .resizable()
                        .frame(width: size, height: size)
                        .shadow(radius: 2)
                }
            }
            .offset(y: yOffset) // Lo mueve a la esquina
        }

        // --- Lógica de Posicionamiento ---
        private var yOffset: CGFloat {
            let radius = hexagonLayout.size / 2
            let yOffsetFromHexagonCenter = sin(Angle.degrees(30).radians) * radius
            return radius - yOffsetFromHexagonCenter - (size / 2)
        }
        
        private var badges: [Badge] { moment.badges }
        private var size: CGFloat { hexagonLayout.size / 5 }
    }
