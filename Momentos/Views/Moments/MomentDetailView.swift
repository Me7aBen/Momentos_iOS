//
//  MomentDetailView.swift
//  Momentos
//
//  Created by Brian Benjamin Pareja Meruvia on 5/11/25.
//

import SwiftUI
import SwiftData


struct MomentDetailView: View {
    var moment: Moment // Recibe el momento que debe mostrar
    @State private var showConfirmation = false

    @Environment(\.dismiss) private var dismiss
    @Environment(DataContainer.self) private var dataContainer

    var body: some View {
        ScrollView {
            contentStack
        }
        .navigationTitle(moment.title) // Título dinámico
        .toolbar {
            ToolbarItem(placement: .destructiveAction) {
                Button {
                    showConfirmation = true
                } label: {
                    Image(systemName: "trash") // Botón de eliminar
                }
                .confirmationDialog("Eliminar Momento", isPresented: $showConfirmation) {
                    Button("Eliminar Momento", role: .destructive) {
                        // Lógica de eliminación
                        dataContainer.context.delete(moment)
                        try? dataContainer.context.save()
                        dismiss() // Cierra la vista de detalle
                    }
                } message: {
                    Text("El momento será eliminado permanentemente.")
                }
            }
        }
    }

    private var contentStack: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(moment.timestamp, style: .date) // Muestra la fecha
                Text(moment.category)
                    .font(.subheadline)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.secondary.opacity(0.15))
                    .clipShape(Capsule())
                Spacer()
                // (Aquí irán las insignias en la próxima sesión)
                ForEach(moment.badges) { badge in
                    NavigationLink {
                        // Destino: La vista de detalle del logro
                        BadgeDetailView(badge: badge)
                    } label: {
                        // Etiqueta: La imagen del logro
                        Image(badge.details.image)
                            .resizable()
                            .frame(width: 44, height: 44)
                    }
                }
            }
            if !moment.note.isEmpty {
                Text(moment.note) // Muestra la nota
                    .textSelection(.enabled) // Permite copiar el texto
            }
            if let image = moment.image {
                Image(uiImage: image) // Muestra la imagen
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

#Preview {
    NavigationStack {
        MomentDetailView(moment: .imageSample)
            .sampleDataContainer()
    }
}
