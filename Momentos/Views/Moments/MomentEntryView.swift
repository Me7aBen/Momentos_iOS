// Momentos/Views/Moments/MomentEntryView.swift

import SwiftUI
import PhotosUI
import SwiftData

struct MomentEntryView: View {
    // --- Variables de Estado ---
    @State private var title = ""
    @State private var note = ""
    @State private var imageData: Data?
    @State private var newImage: PhotosPickerItem?
    @State private var isShowingCancelConfirmation = false
    @State private var category: MomentCategory = .otro // <-- AÑADIR ESTADO

    // --- Variables de Entorno ---
    @Environment(\.dismiss) private var dismiss
    @Environment(DataContainer.self) private var dataContainer

    var body: some View {
        NavigationStack {
            ScrollView {
                contentStack
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Agradecido Por...")
            .toolbar {
                // Botón de Cancelar
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar", systemImage: "xmark") {
                        // MODIFICAR lógica de confirmación
                        if title.isEmpty && note.isEmpty && imageData == nil && category == .otro {
                            dismiss()
                        } else {
                            isShowingCancelConfirmation = true
                        }
                    }
                    .confirmationDialog("Descartar Momento", isPresented: $isShowingCancelConfirmation) {
                        Button("Descartar Momento", role: .destructive) {
                            dismiss()
                        }
                    } message: {
                        Text("¿Estás seguro de que quieres descartar este momento?")
                    }
                }

                // Botón de Guardar
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar", systemImage: "checkmark") {
                        saveMoment()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveMoment() {
        // 1. Crea el nuevo objeto Momento
        let newMoment = Moment(
            title: title,
            note: note,
            imageData: imageData,
            timestamp: .now,
            category: category // <-- AÑADIR CATEGORÍA AL GUARDAR
        )
        
        // 2. Inserta el objeto
        dataContainer.context.insert(newMoment)
        
        do {
             try dataContainer.badgeManager.unlockBadges(newMoment: newMoment)
            
            // 3. Intenta guardar
            try dataContainer.context.save()
            
            // 4. Cierra la vista
            dismiss()
        } catch {
            print("Error al guardar el momento: \(error)")
        }
    }

    // --- Sub-Vistas ---
    
    // Vista para el selector de fotos (sin cambios)
    private var photoPicker: some View {
        PhotosPicker(selection: $newImage) {
            Group {
                if let imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(systemName: "photo.badge.plus.fill")
                        .font(.largeTitle)
                        .frame(height: 250)
                        .frame(maxWidth: .infinity)
                        .background(Color(white: 0.4, opacity: 0.32))
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .onChange(of: newImage) {
            guard let newImage else { return }
            Task {
                imageData = try await newImage.loadTransferable(type: Data.self)
            }
        }
    }

    // --- VISTA "BONITA" PARA EL PICKER ---
    // Este es el nuevo selector de categoría
    private var categoryPicker: some View {
        // El Picker estilo .menu se renderiza como un botón.
        // Personalizamos la "etiqueta" (label) de ese botón
        // para que muestre la categoría actual con su icono y color.
        Picker(selection: $category) {
            // 1. Estas son las opciones del menú
            ForEach(MomentCategory.allCases) { category in
                Label(category.title, systemImage: category.systemImage)
                    .tag(category)
            }
        } label: {
            // 2. Esta es la etiqueta del "botón" que se ve siempre
            HStack {
                Label {
                    Text(category.title) // El título de la categoría seleccionada
                } icon: {
                    Image(systemName: category.systemImage) // El icono
                        .foregroundStyle(category.color) // Con su color
                        .font(.headline)
                        .frame(width: 25) // Ayuda a alinear
                }
                Spacer()
                // El "chevron" (>) se añade automáticamente por el Picker
            }
            .font(.headline)
            .foregroundStyle(.primary)
        }
        .pickerStyle(.menu) // ¡El estilo clave!
        .padding(.vertical, 4) // Un poco de espacio
    }
    
    // Vista para el contenido principal del formulario
    var contentStack: some View {
        VStack(alignment: .leading) {
            TextField(text: $title) {
                Text("Título (Requerido)")
            }
            .font(.title.bold())
            .padding(.top, 48)
            Divider()

            TextField("Anota tus pequeñas victorias...", text: $note, axis: .vertical)
                .multilineTextAlignment(.leading)
                .lineLimit(5...Int.max)

            // --- AÑADIR ESTE BLOQUE MODIFICADO ---
            Divider()
            categoryPicker // Usamos la vista "bonita" que acabamos de crear
            Divider()
            // --- FIN DEL BLOQUE AÑADIDO ---

            photoPicker
        }
        .padding()
    }
}

#Preview {
    MomentEntryView()
        .sampleDataContainer()
}
