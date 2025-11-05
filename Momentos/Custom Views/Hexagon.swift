//
//  Hexagon.swift
//  Momentos
//
//  Created by Brian Benjamin Pareja Meruvia on 5/11/25.
//

import SwiftUI

    struct Hexagon<Content: View>: View {
        private let borderWidth = 2.0
        var borderColor: Color = .ember
        var layout: HexagonLayout = .standard
        var moment: Moment? = nil
        @ViewBuilder var content: () -> Content

        var body: some View {
            ZStack {
                // Si el momento tiene imagen, la ponemos de fondo
                if let background = moment?.image {
                    Image(uiImage: background)
                        .resizable()
                        .scaledToFill()
                }

                // El contenido (título, nota) va encima
                content()
                    .frame(width: layout.size, height: layout.size)
            }
            // --- Aquí está la magia ---
            // 1. Recortamos todo el ZStack con forma de hexágono
            .mask {
                Image(systemName: "hexagon.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: layout.size - borderWidth, height: layout.size - borderWidth)
                    .fontWeight(.ultraLight)
            }
            // 2. Añadimos un fondo que es solo el borde del hexágono
            .background {
                Image(systemName: "hexagon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: layout.size, height: layout.size)
                    .foregroundStyle(borderColor)
                    .fontWeight(.ultraLight)
            }
            // 3. Definimos el tamaño final del control
            .frame(width: layout.size, height: layout.size)
            // 4. (En la próxima sesión, aquí pondremos la insignia)
            // .overlay(alignment: .topTrailing) {
            //     if let moment {
            //         HexagonAccessoryView(moment: moment, hexagonLayout: layout)
            //     }
            // }
        }
    }

    #Preview {
        Hexagon(moment: Moment.imageSample) {
            Text(Moment.imageSample.title)
                .foregroundStyle(Color.white)
        }
        .sampleDataContainer()
    }
