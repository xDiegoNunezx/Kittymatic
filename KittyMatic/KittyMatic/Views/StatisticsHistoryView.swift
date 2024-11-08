//
//  StatisticsHistoryView.swift
//  kittymatic2
//
//  Created by Ana Cecilia Fragoso Islas on 05/11/24.
//

import SwiftUI
import Charts

struct FeedingRecord {
    var date: Date
    var amount: Int
}

struct StatisticsHistoryView: View {
    @ObservedObject var viewModel: CatViewModel
    @State private var feedingRecords: [FeedingRecord] = [
        FeedingRecord(date: Date().addingTimeInterval(-86400 * 3), amount: 50), // 3 días atrás
        FeedingRecord(date: Date().addingTimeInterval(-86400 * 2), amount: 40), // 2 días atrás
        FeedingRecord(date: Date().addingTimeInterval(-86400), amount: 60),   // 1 día atrás
        FeedingRecord(date: Date(), amount: 55) // Hoy
    ]
    
    // Función para calcular el total y el promedio
    var totalFoodAmount: Int {
        feedingRecords.reduce(0) { $0 + $1.amount }
    }
    
    var averageDailyFood: Double {
        feedingRecords.isEmpty ? 0 : Double(totalFoodAmount) / Double(feedingRecords.count)
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.87, green: 0.94, blue: 1.0) // Fondo azul bebé
                .ignoresSafeArea()
            
            ScrollView { // Añadir un ScrollView aquí
                VStack(spacing: 20) {
                    Text("Estadísticas de Alimentación")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                    
                    // Gráfico de barras de comida por día
                    Chart {
                        ForEach(feedingRecords, id: \.date) { record in
                            BarMark(
                                x: .value("Fecha", record.date, unit: .day),
                                y: .value("Comida (gr)", record.amount)
                            )
                            .foregroundStyle(Color(hex: "608BC1"))
                        }
                    }
                    .frame(height: 300)
                    .padding()
                    
                    // Resumen General
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Resumen General")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        HStack {
                            Text("Total Comida Dispensada: \(totalFoodAmount) gr")
                                .font(.title3)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        
                        HStack {
                            Text("Promedio Diario: \(String(format: "%.2f", averageDailyFood)) gr")
                                .font(.title3)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        
                        HStack {
                            Text("Comidas Registradas: \(feedingRecords.count)")
                                .font(.title3)
                                .foregroundColor(.black)
                            Spacer()
                        }
                    }
                    .padding()
                    
                    // Historial de Comidas
                    VStack(alignment: .leading) {
                        Text("Historial de Comidas")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.top, 20)
                        
                        // Usando List para mostrar los registros
                        ForEach(feedingRecords, id: \.date) { record in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Comida de \(record.date, style: .date) a las \(record.date, style: .time)")
                                        .font(.body)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Text("\(record.amount) gr")
                                    .font(.body)
                                    .foregroundColor(.blue)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .padding([.leading, .trailing], 20)
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct CatFeedingStatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsHistoryView(viewModel: CatViewModel.ejemplo)
    }
}
