//
//  CatProfileView.swift
//  kittymatic2
//
//  Created by Ana Cecilia Fragoso Islas on 05/11/24.
//

import SwiftUI

struct CatProfileView: View {
    // Modelo de perfil de gato (para el detalle)
    @ObservedObject var viewModel: CatViewModel
    @State var age: Int = 0
    @State var weight: Double = 0.0
    @State var breed: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.87, green: 0.94, blue: 1.0) // Fondo azul bebé
                    .ignoresSafeArea()  // Este fondo puede ignorar el área segura
                
                VStack() {
                    // Foto y nombre del gato
                    HStack(spacing: 40) {
                        VStack{
                            
                            if let photoData = viewModel.cat?.photo, let uiImage = UIImage(data: photoData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 140, height: 140)
                                    .cornerRadius(15)
                                    .shadow(radius: 5)
                                    .padding(.top, 30)
                            } else {
                                Image(systemName: "cat")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.gray)
                            }
                            
                            Text(viewModel.cat?.name ?? "")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.primary)
                        }
                        
                        
                        // Información sobre edad y peso
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Edad: " + String(age) + " años")
                                .font(.title3)
                                .foregroundColor(.black)
                            
                            Text("Peso: " + String(weight) + " kg")
                                .font(.title3)
                                .foregroundColor(.black)
                            
                            Text("Raza: " + breed)
                                .font(.title3)
                                .foregroundColor(.black)
                        }
                        .padding(.top, 5)
                    }
                    
                    // Sección de horarios de comida
                    VStack(alignment: .center) {
                        Text("Horarios de comida")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .padding(.top, 15)
                        
                        if let schedule = viewModel.cat?.schedule {
                            ForEach(schedule, id: \.self) { meal in
                                HStack {
                                    Text("45 g")
                                        .font(.title3)
                                        .foregroundColor(.gray)
                                    
                                    Spacer()
                                    
                                    Text(meal)
                                        .font(.title3)
                                        .foregroundColor(.blue)
                                }
                                .padding(.top, 10)
                            }
                        } else {
                            Text("No hay horarios de comida")
                                .font(.title3)
                                .foregroundColor(.gray)
                                .padding(.top, 10)
                        }
                        
                    }
                    
                    // Botón de historial de estadísticas
                    Spacer()
                    
                    NavigationLink {
                        FeedingReportsHistoryView(viewModel: viewModel)
                    } label: {
                        Text("Ver Historial de Estadísticas")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding([.leading, .trailing], 20)
                            .padding(.bottom, 30)
                    }
                    .padding(.top, 30)
                }
                .padding()  // Este padding asegura que el contenido no se salga del área segura
                .edgesIgnoringSafeArea(.bottom)  // Solo si el fondo necesita extenderse hacia abajo
            }
            .onAppear {
                if let cat = viewModel.cat {
                    age = cat.age
                    weight = cat.weight
                    breed = cat.breed
                }
                
            }
        }
    }
}

// Vista previa para ver el diseño
struct CatProfileDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CatProfileView(viewModel: CatViewModel.ejemplo)
    }
}

