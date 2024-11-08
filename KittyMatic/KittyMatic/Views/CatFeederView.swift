//
//  ContentView.swift
//  kittymatic2
//
//  Created by Ana Cecilia Fragoso Islas on 05/11/24.
//
import SwiftUI

struct CatFeederView: View {
    @ObservedObject var viewModel: CatViewModel
    @State private var currentTime = Date()
    @State private var gramosConsumidos: Double = 0.5
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.87, green: 0.94, blue: 1.0) // Fondo azul bebé
                    .ignoresSafeArea()
                
                VStack(spacing: 25) {
                    // Banner con Fecha y Hora en tiempo real
                    Text(dateFormatter.string(from: currentTime))
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.top, 10)
                    
                    Text("ID del dispositivo: HBLS5302")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, -20)
                    
                    // Foto del Gato y Nombre (como botón)
                    HStack(spacing: 20) {
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
                        
                        VStack(alignment: .leading) {
                            NavigationLink {
                                CatProfileView(viewModel: viewModel)
                            } label: {
                                Text(viewModel.cat?.name ?? "")
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundColor(.primary)
                            }
                            
                            Text("🍽️ Monitoreando...")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Sección de Gramos Consumidos
                    HStack(alignment: .center, spacing: 15) {
                        Image(systemName: "pawprint.fill")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text(String(gramosConsumidos))
                                .font(.system(size: 48))
                                .fontWeight(.bold)
                            Text("consumidos hoy         ")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                    // Sección de Nivel de Comida
                    HStack(alignment: .center, spacing: 20) {
                        Image(systemName: "fork.knife")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text(String(viewModel.fullAmount))
                                .font(.system(size: 48))
                                .fontWeight(.bold)
                            Text("de comida disponible")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                    // Botones de Acciones
                    HStack(spacing: 20) {
                        Button(action: {
                            // Acción para dispensar comida
                        }) {
                            VStack {
                                Image(systemName: "tray.and.arrow.down.fill")
                                    .font(.title)
                                    .foregroundColor(.blue)
                                Text("Dispensar")
                                    .font(.title3)
                                    .foregroundColor(.primary)
                            }
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(15)
                        }
                        
                        NavigationLink {
                            StatisticsHistoryView(viewModel: viewModel)
                        } label: {
                            VStack {
                                Image(systemName: "chart.bar.fill")
                                    .font(.title)
                                    .foregroundColor(.blue)
                                Text("Análisis")
                                    .font(.title3)
                                    .foregroundColor(.primary)
                            }
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(15)
                        }
                        
                        Button(action: {
                            // Acción para reproducir sonido
                        }) {
                            VStack {
                                Image(systemName: "speaker.wave.2.fill")
                                    .font(.title)
                                    .foregroundColor(.blue)
                                Text("Sonido")
                                    .font(.title3)
                                    .foregroundColor(.primary)
                            }
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(15)
                        }
                    }
                    .padding(.top, 20)
                }
                .padding()
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                        self.currentTime = Date()
                    }
                }
                
                // Botón "+" fuera del área segura para agregar un nuevo gato
                VStack {
                    HStack {
                        Button(action: {
                            print("Switch Button Pressed")
                            viewModel.fullAmount = 100.0
                            // Lógica para el botón de "switch"
                        }) {
                            Image(systemName: "arrow.trianglehead.counterclockwise")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                                .padding()
                                .offset(x: 10)
                        }
                        
                        Spacer()
                        Button(action: {
                            print("add button pressed")
                            viewModel.delete()
                        }){
                            Image(systemName: "plus.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.blue)
                                .padding()
                                .offset(x: -10)
                        }                        
                    }
                    Spacer()
                }
                .padding(.bottom,10)
            }
        }
        .onAppear {
            gramosConsumidos = viewModel.getGramosConsumidos()
        }
    }
}

struct CatFeederView_Previews: PreviewProvider {
    static var previews: some View {
        CatFeederView(viewModel: CatViewModel.ejemplo)
    }
}



