// Momentos/Views/Moments/MomentDetailView.swift

import SwiftUI
import SwiftData

struct MomentDetailView: View {
    var moment: Moment
    @State private var showConfirmation = false

    @Environment(\.dismiss) private var dismiss
    @Environment(DataContainer.self) private var dataContainer

    var body: some View {
        ScrollView {
            contentStack
        }
        .navigationTitle(moment.title)
        .toolbar {
            ToolbarItem(placement: .destructiveAction) {
                Button {
                    showConfirmation = true
                } label: {
                    Image(systemName: "trash")
                }
                .confirmationDialog("Eliminar Momento", isPresented: $showConfirmation) {
                    Button("Eliminar Momento", role: .destructive) {
                        dataContainer.context.delete(moment)
                        try? dataContainer.context.save()
                        dismiss()
                    }
                } message: {
                    Text("El momento será eliminado permanentemente.")
                }
            }
        }
    }

    // --- PÍLDORA DE CATEGORÍA ---
    private var categoryPill: some View {
        Label(moment.category.title, systemImage: moment.category.systemImage)
            .font(.caption.bold())
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .foregroundStyle(.white) // Texto blanco
            .background(moment.category.color.gradient) // Fondo con color
            .clipShape(Capsule()) // Forma de píldora
    }
    // --- FIN DE LA PÍLDORA ---

    private var contentStack: some View {
        VStack(alignment: .leading, spacing: 16) { // Añadido espaciado
            HStack {
                Text(moment.timestamp, style: .date)
                    .font(.subheadline)
                    .foregroundStyle(.secondary) // Tono más suave
                Spacer()
                ForEach(moment.badges) { badge in
                    NavigationLink {
                        BadgeDetailView(badge: badge)
                    } label: {
                        Image(badge.details.image)
                            .resizable()
                            .frame(width: 44, height: 44)
                    }
                }
            }
            
            categoryPill // <-- AÑADIMOS LA PÍLDORA AQUÍ
            
            if !moment.note.isEmpty {
                Text(moment.note)
                    .textSelection(.enabled)
            }
            if let image = moment.image {
                Image(uiImage: image)
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
