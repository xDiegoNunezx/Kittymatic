//
//  Untitled.swift
//  kittymatic2
//
//  Created by Ana Cecilia Fragoso Islas on 05/11/24.
//
import SwiftUI

struct CatFeederFormView: View {
    @ObservedObject var viewModel: CatViewModel
    
    @Environment(\.presentationMode) var presentationMode
    @State private var catName: String = ""
    @State private var catAge: Int = 0
    @State private var catWeight: Double = 0.0
    @State private var catBreed: String = "American Short Hair"
    @State private var photo: UIImage? = nil
    @State private var nuevoHorario = Date()  // Cambiado a Date para el DatePicker
    @State private var horariosComida: [Date] = []  // Array de Date para almacenar los horarios
    @State private var showingImagePicker = false
    @State private var selectedPhotoIndex: Int = 0
    
    // Propiedad calculada para verificar si el formulario es válido
    private var formularioValido: Bool {
        !catName.isEmpty && catAge > 0 && catWeight > 0 && photo != nil && !horariosComida.isEmpty
    }
    
    var body: some View {
        ScrollView {
            // Título de la pantalla
            Text("Información sobre tu gato")
                .font(.system(size: 30))
                .font(.largeTitle)
                .bold()
                .foregroundColor(.black)
                .padding(.top, 30)
            
            VStack {
                // Formulario
                VStack(spacing: 20) {
                    // Información del gato
                    VStack(alignment: .leading) {
                        Text("¿Cómo se llama?")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        
                        TextField("",text: $catName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom, 10)
                        
                        Text("¿Qué edad tiene? (años)")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        
                        TextField("", value: $catAge, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom, 20)
                        
                        Text("¿Cuánto pesa? (kg)")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        
                        TextField("", value: $catWeight, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom, 20)
                    }
                    .padding([.leading, .trailing], 20)
                    
                    // Sección de fotos
                    VStack(alignment: .leading) {
                        Text("Coloca una foto de tu gato                ")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                        Text("La analizaremos para identificar su raza y la cantidad de comida recomendada")
                            .font(.subheadline)
                            .padding(.bottom, 15)
                        
                        Button(action: {
                            showingImagePicker.toggle()
                        }) {
                            HStack(alignment: .center) {
                                if let photo = photo {
                                    Image(uiImage: photo)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(10)
                                } else {
                                    Text("Agregar foto")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.bottom, 10)
                        }
                        .sheet(isPresented: $showingImagePicker) {
                            ImagePicker(image: $photo)
                        }
                        
                        
                        Text("Coloca los horarios sus comida                ")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                        DatePicker("Seleccionar horario", selection: $nuevoHorario, displayedComponents: .hourAndMinute)
                        
                        Button(action: agregarHorario) {
                            Text("Agregar Horario")
                        }
                    }
                    .padding([.leading, .trailing], 20)
                    
                    
                    
                    // Lista de horarios agregados
                    
                    ForEach(horariosComida, id: \.self) { horario in
                        Text(formatearHora(horario))
                    }
                    
                    
                    
                    // Spacer para balancear el diseño
                    Spacer()
                    
                    
                    // Botón Agregar Gato
                    Button(action: {
                        let fotoData = photo?.jpegData(compressionQuality: 0.8)
                        
                        viewModel.cat = Cat(name: catName, age: catAge, weight: catWeight, breed: catBreed, photo: fotoData, schedule: horariosComida.map { formatearHora($0) }, history: [], amount: 45)
                        
                        viewModel.save()
                    }) {
                        Text("Agregar Gato")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .disabled(!formularioValido)
                    
                }
                .padding([.top, .bottom], 20)
                .cornerRadius(20)
                .padding([.leading, .trailing], 20)
                
            }
        }
        .background(Color.blue.opacity(0.15)
            .edgesIgnoringSafeArea(.all))
        .onTapGesture {
            UIApplication.shared.closeKeyboard()
        }
    } // Fondo azul bebé que cubre toda la pantalla
    
    
    // Función para agregar un nuevo horario
    private func agregarHorario() {
        horariosComida.append(nuevoHorario)
    }
    
    // Función para eliminar un horario
    private func eliminarHorario(at offsets: IndexSet) {
        horariosComida.remove(atOffsets: offsets)
    }
    
    // Función para formatear la hora para mostrarla en la lista
    private func formatearHora(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

struct CatFeederFormView_Previews: PreviewProvider {
    static var previews: some View {
        CatFeederFormView(viewModel: CatViewModel.ejemplo)
    }
}

import SwiftUI

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
