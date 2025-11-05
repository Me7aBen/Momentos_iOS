//
//  MomentHexagonView.swift
//  Momentos
//
//  Created by Brian Benjamin Pareja Meruvia on 5/11/25.
//

import SwiftUI

    // Esta vista se especializa en mostrar un 'Moment' dentro de un 'Hexagon'.
    struct MomentHexagonView: View {
        var moment: Moment
        @State var layout: HexagonLayout = .standard
        
        // Locale nos ayuda a formatear la fecha correctamente
        // según la región del usuario (ej. "Nov 5" vs "5 Nov")
        @Environment(\.locale) private var locale

        var body: some View {
            Hexagon(layout: layout, moment: moment) {
                hexagonContent()
            }
        }

        private func hexagonContent() -> some View {
            ZStack(alignment: .bottom) {
                if showImage {
                    // Fondo transparente con material borroso para el texto
                    Color.clear
                    contentStack()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                        .background(.ultraThinMaterial) // Efecto "vidrio esmerilado"
                } else {
                    // Fondo de color sólido
                    Color.ember
                    contentStack()
                        .frame(height: layout.size * 0.80)
                }

                // Fecha en la parte inferior
                Text(moment.timestamp.formatted(
                    .dateTime.locale(locale)
                    .month(.abbreviated).day()
                ))
                .font(.footnote)
                .padding(.bottom, layout.size * 0.08)
                .frame(maxWidth: layout.size / 3)
                .frame(maxHeight: layout.timestampHeight)
            }
            .foregroundStyle(.white) // Color del texto (fecha, título, nota)
        }

        private func contentStack() -> some View {
            VStack(alignment: .leading) {
                Text(moment.title)
                    .font(layout.titleFont)
                // Solo mostramos la nota si NO hay imagen
                if !moment.note.isEmpty, !showImage {
                    Text(moment.note)
                        .font(layout.bodyFont)
                }
            }
            .frame(maxWidth: layout.size * 0.80)
            .frame(maxHeight: layout.size * (showImage ? 0.15 : 0.50))
            .padding(.bottom, layout.size * layout.textBottomPadding)
            .fixedSize(horizontal: false, vertical: true)
        }

        // Propiedad computada para saber si mostramos la imagen
        private var showImage: Bool {
            moment.image != nil
        }
    }

    #Preview {
        ScrollView {
            MomentHexagonView(moment: Moment.imageSample)
            MomentHexagonView(moment: Moment.sample, layout: .large)
        }
        .sampleDataContainer()
    }
