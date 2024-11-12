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
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Sección de foto y nombre
                    VStack {
                        if let photoData = viewModel.cat?.photo, let uiImage = UIImage(data: photoData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 140, height: 140)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                                .padding(.top, 30)
                        } else {
                            Image(systemName: "cat")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                        }
                        
                        Text(viewModel.cat?.name ?? "Nombre del Gato")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.primary)
                            .padding(.top, 10)
                    }
                    
                    // Información de edad, peso y raza
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Edad:")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            Text("\(age) años")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("Peso:")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            Text(String(format: "%.1f kg", weight))
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("Raza:")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            Text(breed)
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    
                    // Sección de horarios de comida
                    VStack(alignment: .leading) {
                        Text("Horarios de Comida")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .padding(.bottom, 5)
                        
                        if let schedule = viewModel.cat?.schedule {
                            VStack(spacing: 8) {
                                ForEach(schedule, id: \.self) { meal in
                                    HStack {
                                        Text("45 g")
                                            .font(.callout)
                                            .foregroundColor(.gray)
                                        
                                        Spacer()
                                        
                                        Text(meal)
                                            .font(.callout)
                                            .foregroundColor(.blue)
                                    }
                                    .padding(10)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 2)
                                }
                            }
                        } else {
                            Text("No hay horarios de comida")
                                .font(.callout)
                                .foregroundColor(.gray)
                                .padding(10)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    
                    Spacer()
                    
                
                
                }
                .padding()
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
}

// Vista previa para ver el diseño
struct CatProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CatProfileView(viewModel: CatViewModel.ejemplo)
    }
}
