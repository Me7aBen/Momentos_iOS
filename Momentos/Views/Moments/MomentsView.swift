//
//  MomentsView.swift
//  Momentos
//
//  Created by Brian Benjamin Pareja Meruvia on 5/11/25.
//

import SwiftUI
    import SwiftData

    struct MomentsView: View {
        @State private var showCreateMoment = false
        
        // --- ¡Magia de SwiftData! ---
        // @Query le pide a SwiftData todos los 'Moment'
        // y los ordena por 'timestamp'.
        // Esta variable SIEMPRE está actualizada.
        @Query(sort: \Moment.timestamp)
        private var moments: [Moment]

        static let offsetAmount: CGFloat = 70.0 // Cantidad de zigzag

        var body: some View {
            NavigationStack {
                ScrollView {
                    // LazyVStack es más eficiente que un VStack normal,
                    // ya que solo renderiza las vistas que están en pantalla.
                    LazyVStack(spacing: 8) {
                        pathItems
                            .frame(maxWidth: .infinity)
                    }
                }
                .overlay {
                    // Si no hay momentos, muestra un mensaje amigable
                    if moments.isEmpty {
                        ContentUnavailableView {
                            Label("¡Aún no hay momentos!", systemImage: "exclamationmark.circle.fill")
                        } description: {
                            Text("Publica una nota o foto para empezar a llenar este espacio con gratitud.")
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            showCreateMoment = true // Abre la hoja modal
                        } label: {
                            Image(systemName: "plus")
                        }
                        .sheet(isPresented: $showCreateMoment) {
                            MomentEntryView() // Presenta el formulario
                        }
                    }
                }
                .navigationTitle("Momentos de Gratitud")
            }
            .dynamicTypeSize(...DynamicTypeSize.xxxLarge) // Soporte para fuentes grandes
        }

        private var pathItems: some View {
            // 'enumerated()' nos da el (índice, momento)
            ForEach(moments.enumerated(), id: \.0) { index, moment in
                
                NavigationLink {
                    // Destino: La vista de detalle con el momento seleccionado
                    MomentDetailView(moment: moment)
                } label: {
                    // El contenido (la "etiqueta") del link es nuestro hexágono
                    if moment == moments.last {
                        // El último momento es grande
                        MomentHexagonView(moment: moment, layout: .large)
                    } else {
                        // Los demás son de tamaño estándar
                        MomentHexagonView(moment: moment)
                            // Efecto de zigzag
                            .offset(x: sin(Double(index) * .pi / 2) * Self.offsetAmount)
                    }
                }
                .scrollTransition { content, phase in // Pequeña animación de entrada
                    content
                        .opacity(phase.isIdentity ? 1 : 0)
                        .scaleEffect(phase.isIdentity ? 1 : 0.8)
                }
            }
        }
    }

    #Preview {
        MomentsView()
            .sampleDataContainer()
    }
