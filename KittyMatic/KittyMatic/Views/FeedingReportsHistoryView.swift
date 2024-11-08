//
//  Untitled.swift
//  kittymatic2
//
//  Created by Ana Cecilia Fragoso Islas on 05/11/24.
//

import SwiftUI
import Charts

struct FeedingReportsHistoryView: View {
    @ObservedObject var viewModel: CatViewModel
    
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // Formato de 24 horas
        return dateFormatter
    }
    
    var body: some View {
        ZStack {
            Color(hex: "CBDCEB")
                .ignoresSafeArea()
            
            if let history = viewModel.cat?.history {
                ForEach(history, id: \.date) { report in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Reporte de Comida")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text("Comió " + String(report.amount) + " gr")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text(report.date, style: .date)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
            } else {
                Text("No hay horarios de comida")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
            }
        }
        .navigationTitle("Historial de Comidas")
        .navigationBarHidden(true)
    }
}

struct FeedingReportsHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        FeedingReportsHistoryView(viewModel: CatViewModel.ejemplo)
    }
}

