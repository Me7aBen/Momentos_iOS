//
//  MomentEntryView.swift
//  Momentos
//
//  Created by Brian Benjamin Pareja Meruvia on 5/11/25.
//

import SwiftUI
import PhotosUI // Para el selector de fotos
import SwiftData

struct MomentEntryView: View {
    // --- Variables de Estado ---
    // @State significa que la vista "posee" esta variable.
    // Cuando cambia, la vista se redibuja.
    @State private var title = ""
    @State private var note = ""
    @State private var category: MomentCategory = .familia
    @State private var imageData: Data?
    @State private var newImage: PhotosPickerItem? // Para el item seleccionado
    @State private var isShowingCancelConfirmation = false

    // --- Variables de Entorno ---
    // @Environment nos da acceso a valores globales.
    @Environment(\.dismiss) private var dismiss // Para cerrar la vista
    @Environment(DataContainer.self) private var dataContainer // Nuestro gestor de datos

    var body: some View {
        NavigationStack {
            ScrollView {
                contentStack
            }
            .scrollDismissesKeyboard(.interactively) // El teclado se oculta al hacer scroll
            .navigationTitle("Agradecido Por...")
            .toolbar {
                // Botón de Cancelar
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar", systemImage: "xmark") {
                        if title.isEmpty && note.isEmpty && imageData == nil {
                            dismiss() // Si no hay nada escrito, solo cierra
                        } else {
                            // Si hay datos, pide confirmación
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
                    // Se deshabilita si el título está vacío
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
            category: category.rawValue
        )
        
        // 2. Inserta el objeto en el 'Contexto' de SwiftData
        dataContainer.context.insert(newMoment)
        
        do {
            // (En la próxima sesión, aquí llamaremos a 'unlockBadges')
             try dataContainer.badgeManager.unlockBadges(newMoment: newMoment)
            
            // 3. Intenta guardar el contexto en la base de datos
            try dataContainer.context.save()
            
            // 4. Cierra la vista modal
            dismiss()
        } catch {
            // Si hay un error, no cerramos la vista
            print("Error al guardar el momento: \(error)")
        }
    }

    // --- Sub-Vistas ---
    
    // Vista para el selector de fotos
    private var photoPicker: some View {
        // Este es el componente nativo de SwiftUI para elegir fotos
        PhotosPicker(selection: $newImage) {
            Group {
                if let imageData, let uiImage = UIImage(data: imageData) {
                    // Si ya tenemos una imagen, la mostramos
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                } else {
                    // Si no, mostramos un ícono
                    Image(systemName: "photo.badge.plus.fill")
                        .font(.largeTitle)
                        .frame(height: 250)
                        .frame(maxWidth: .infinity)
                        .background(Color(white: 0.4, opacity: 0.32))
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        // Se activa cuando el usuario elige una imagen
        .onChange(of: newImage) {
            guard let newImage else { return }
            Task {
                // Convertimos el 'PhotosPickerItem' a 'Data'
                imageData = try await newImage.loadTransferable(type: Data.self)
            }
        }
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
                .lineLimit(5...Int.max) // Permite que el texto crezca

                HStack {
                    Text("Categoría")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Menu {
                        ForEach(MomentCategory.allCases) { cat in
                            Button {
                                category = cat
                            } label: {
                                Label(cat.displayName, systemImage: cat.iconName)
                                if cat == category {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    } label: {
                        Label(category.displayName, systemImage: category.iconName)
                            .labelStyle(.titleAndIcon)
                            .padding(8)
                            .background(Color.secondary.opacity(0.12))
                            .clipShape(Capsule())
                    }
                }
                .padding(.vertical, 8)

            photoPicker
        }
        .padding()
    }
}

#Preview {
    MomentEntryView()
        .sampleDataContainer() // ¡Usamos nuestro truco para la preview!
}
