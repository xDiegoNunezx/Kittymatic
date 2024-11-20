//
//  ContentView.swift
//  kittymatic2
//
//  Created by Ana Cecilia Fragoso Islas on 05/11/24.
//
import SwiftUI

struct CatFeederView: View {
    @EnvironmentObject var viewModel: CatViewModel
    @EnvironmentObject var mqttManager: MQTTManager
    @State private var currentTime = Date()
    @State private var gramosConsumidos: Double = 0.0
    @State private var canFeed: Bool = true
    
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
                
                ScrollView(.vertical, showsIndicators: true) {
                    // Botón "+" fuera del área segura para agregar un nuevo gato
                    VStack {
                        HStack {
                            Button(action: {
                                print("Reset Button Pressed")
                                mqttManager.sendMsg(onTopic: "Orden", withMessage: "comidaDisponible")
                                viewModel.fullAmount = getComidaDisponible()
                                canFeed = true
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
                    // Banner con Fecha y Hora en tiempo real
                    Text(dateFormatter.string(from: currentTime))
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        
                    
                    Text("ID del dispositivo: HBLS5302")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .background(Color.white.opacity(0.8))
                        .onTapGesture {
                            mqttManager.connect()
                        }
                    
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
                            let percentage: Double = ((viewModel.fullAmount * 100.0) / 22.3)
                            let fullPercentage: Double = 100.0 - percentage
                            Text(String(format: "%.2f% %", fullPercentage))
                                .font(.system(size: 48))
                                .fontWeight(.bold)
                                .foregroundStyle(canFeed ? .black : .red)
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
                            //canFeed = viewModel.dispensar()
                            mqttManager.sendMsg(onTopic: "Orden", withMessage: "dispensar")
                            //gramosConsumidos = viewModel.getGramosConsumidos()
                            print("Dispensando...")
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
                            StatisticsHistoryView()
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
                            mqttManager.sendMsg(onTopic: "Orden", withMessage: "sonido")
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
                
                
            }
        }
        .onAppear {
            gramosConsumidos = viewModel.getGramosConsumidos()
            viewModel.fullAmount = getComidaDisponible()
            mqttManager.sendMsg(onTopic: "Orden", withMessage: "comidaDisponible")
        }
        .onChange(of: mqttManager.messages["cantidad"]) { oldValue, newValue in
            viewModel.fullAmount = getComidaDisponible()
        }
        .onChange(of: mqttManager.messages["comio"]) { oldValue, newValue in
            if let comio = getCuantoComio() {
                viewModel.cat?.history.append(History(date: Date(), amount: comio))
                viewModel.save()
                gramosConsumidos = viewModel.getGramosConsumidos()
            }
        }
        .onChange(of: mqttManager.messages["comio2"]) { oldValue, newValue in
            if let comio = getCuantoComio2() {
                viewModel.cat?.history.append(History(date: comio.1, amount: comio.0))
                viewModel.save()
                gramosConsumidos = viewModel.getGramosConsumidos()
            }            
        }
    }
    
    func getComidaDisponible() -> Double {
        if let latestMessage = mqttManager.messages["cantidad"]?.last {
            Double(latestMessage) ?? 100
        } else {
            100
        }
    }
    
    func getCuantoComio() -> Double? {
        if let latestMessage = mqttManager.messages["comio"]?.last {
            Double(latestMessage) ?? 0.0
        } else {
            0.0
        }
    }
    
    func getCuantoComio2() -> (Double, Date)? {
        if let latestMessage = mqttManager.messages["comio2"]?.last {
            parseInputString(input: latestMessage)
        } else {
            nil
        }
    }
    
    func parseInputString(input: String) -> (Double, Date)? {
        // Separar la cadena en número y hora
        let components = input.split(separator: " ")
        print(components)
        guard components.count == 2 else {
            print("La cadena no tiene el formato correcto")
            return nil
        }
        
        // Convertir el número a Double
        guard let amount = Double(components[0]) else {
            print("No se pudo convertir el número")
            return nil
        }
        
        // Extraer la hora y minuto
        let timeString = String(components[1])
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        timeFormatter.dateFormat = "HH:mm"
        
        // Convertir la hora a un objeto Date usando la fecha actual
        guard let timeDate = timeFormatter.date(from: timeString) else {
            print("No se pudo convertir la hora")
            return nil
        }
        
        // Obtener la fecha actual sin la parte de la hora
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())  // Fecha de hoy a las 00:00
        
        // Crear un objeto Date con la fecha actual y la hora obtenida
        let fullDate = calendar.date(bySettingHour: calendar.component(.hour, from: timeDate),
                                     minute: calendar.component(.minute, from: timeDate),
                                     second: 0,
                                     of: startOfDay)
        
        guard let finalDate = fullDate else {
            print("No se pudo crear la fecha final")
            return nil
        }
        
        return (amount, finalDate)
    }
    
}

struct CatFeederView_Previews: PreviewProvider {
    static var previews: some View {
        CatFeederView()
            .environmentObject(CatViewModel.ejemplo)
            .environmentObject(MQTTManager())
        
    }
}



