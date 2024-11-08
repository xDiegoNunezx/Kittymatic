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
        //delete()
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
        return cat.history.reduce(0) { $0 + $1.amount }
    }
        
    func dispensar() {
        guard let cat else { return }
        fullAmount -= cat.amount
        cat.history.append(History(date: Date(), amount: 0.5))
    }
}

extension CatViewModel {
    static var ejemplo: CatViewModel {
        let viewModel = CatViewModel()
        viewModel.cat = Cat(name: "Misifus", age: 1, weight: 1.0, breed: "Naranja", photo: nil, schedule: ["08:00", "18:00"], history: [History(date: Date(), amount: 0.5)], amount: 45)
        return viewModel
    }
}
