//
//  Untitled.swift
//  kittymatic2
//
//  Created by Ana Cecilia Fragoso Islas on 05/11/24.
//
import SwiftUI
import CoreML

struct CatBreedClassifierModel {
    var model: CatBreedClassifier?
    init() {
        do {
            model = try CatBreedClassifier(configuration: MLModelConfiguration())
        } catch {
            print("Failed to load CatBreedClassifier model: \(error.localizedDescription)")
        }
    }
}


struct CatFeederFormView: View {
    @EnvironmentObject var viewModel: CatViewModel
    @EnvironmentObject var mqttManager: MQTTManager
    
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
    @State private var catBreedClassified: String = ""
    var catBreedClassifier = CatBreedClassifierModel()
    @State private var breedProbabilities: [String: Double] = [:]
    
    
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
                        
                        if let photo, let model = catBreedClassifier.model {
                            Button {
                                predictBreed(model: model)
                            } label: {
                                Text("Analizar gato...")
                            }
                            .buttonStyle(.borderedProminent)
                        }

                        
                       
                        if catBreedClassified != "" {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Predicción de tu gato")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding(.bottom, 10)
                                
                                Text(catBreedClassified.capitalized)
                                    .bold()
                                
                                Divider()
                                
                                let topFiveBreeds = Array(breedProbabilities.sorted(by: { $0.1 > $1.1 }).prefix(5))

                                ForEach(0..<topFiveBreeds.count, id: \.self) { index in
                                    let (breed, probability) = topFiveBreeds[index]
                                    HStack {
                                        Text(breed.capitalized)
                                            .font(.callout)
                                            .frame(width: 140, alignment: .leading)
                                        
                                        ProgressBar(progress: probability)
                                            .frame(height: 20)
                                        
                                        Text(String(format: "%.2f%%", probability * 100)) // Display as percentage
                                    }
                                }
                            }
                            .padding()
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
                        
                        viewModel.cat = Cat(
                            name: catName,
                            age: catAge, weight: catWeight,
                            breed: catBreedClassified,
                            photo: fotoData,
                            schedule: horariosComida.map { formatearHora($0) },
                            history: [],
                            amount: 10)
                        
                        viewModel.save()
                        
                        for horario in horariosComida.map({formatearHora($0)}) {
                            print("Horarios: ", horario)
                            mqttManager.sendMsg(onTopic: "SettearHora", withMessage: horario)
                        }
                        
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
    
    private func predictBreed(model: CatBreedClassifier) {
        
        guard let photo = photo else {
            print("no prediction")
            return
        }
        
        guard let pixelBuffer = photo.toCVPixelBuffer() else {
            print("No pixel buffer")
            return
        }
        do {
            let prediction = try model.prediction(image: pixelBuffer)
            catBreedClassified = prediction.classLabel
            self.breedProbabilities = prediction.dogorcat
        } catch let e {
            print("error ", e)
        }
    }
    
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
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm"
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
        CatFeederFormView()
    }
}

import SwiftUI

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


extension UIImage {
    
    // https://www.hackingwithswift.com/whats-new-in-ios-11
    func toCVPixelBuffer() -> CVPixelBuffer? {
        
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.size.width), Int(self.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}

struct ProgressBar: View {
    var progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.3))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(width: CGFloat(self.progress) * geometry.size.width, height: geometry.size.height)
                    .animation(.easeInOut(duration: 0.5))
            }
            .cornerRadius(10)
        }
    }
}
