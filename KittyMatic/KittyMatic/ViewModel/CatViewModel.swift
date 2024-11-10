//
//  CatViewModel.swift
//  KittyMatic
//
//  Created by Diego Ignacio Nunez Hernandez on 06/11/24.
//

import Foundation

class CatViewModel: ObservableObject {
    @Published var cat: Cat?
    @Published var fullAmount: Double = 0
    
    init() {
        load()
        fullAmount = 100.0
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(cat) {
            UserDefaults.standard.set(encoded, forKey: "catData")
        }
    }
    
    func load() {
        if let savedData = UserDefaults.standard.data(forKey: "catData"),
           let decoded = try? JSONDecoder().decode(Cat.self, from: savedData) {
            cat = decoded
        }
    }
    
    func delete() {
        UserDefaults.standard.removeObject(forKey: "catData")
        cat = nil
    }
    
    func getGramosConsumidos() -> Double {
        guard let cat else { return 0 }
        // Obtener la fecha de hoy (sin hora, solo fecha)
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())  // Comienza a las 00:00 de hoy
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay)! // Termina a las 23:59
        
        // Filtrar los objetos que tienen una fecha dentro del día actual
        let todayHistory = cat.history.filter { history in
            return history.date >= startOfDay && history.date <= endOfDay
        }
        
        // Sumar los amounts de los objetos filtrados
        let totalAmount = todayHistory.reduce(0) { (sum, history) in
            sum + history.amount
        }
        
        return totalAmount
    }
    
    func dispensar() -> Bool {
        guard let cat else { return false }
        if(fullAmount - cat.amount >= 0) {
            fullAmount -= cat.amount
            cat.history.append(History(date: Date(), amount: 0.5))
            return true
        }
        return false
    }
}

extension CatViewModel {
    static var ejemplo: CatViewModel {
        let viewModel = CatViewModel()
        viewModel.cat = Cat(name: "Misifus", age: 1, weight: 1.0, breed: "Naranja", photo: nil, schedule: ["08:00", "18:00"], history: [History(date: Date(), amount: 0.5)], amount: 45)
        return viewModel
    }
}
