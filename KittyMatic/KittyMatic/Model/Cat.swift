//
//  Cat.swift
//  KittyMatic
//
//  Created by Diego Ignacio Nunez Hernandez on 06/11/24.
//

import Foundation

class History: Codable {
    var date: Date
    var amount: Double
    
    init(date: Date, amount: Double) {
        self.date = date
        self.amount = amount
    }
}

class Cat: Codable {
    var name: String
    var age: Int
    var weight: Double
    var breed: String
    var photo: Data?
    var schedule: [String]
    var history: [History]
    var amount: Double
    
    init(name: String, age: Int, weight: Double, breed: String, photo: Data? = nil, schedule: [String], history: [History], amount: Double) {
        self.name = name
        self.age = age
        self.weight = weight
        self.breed = breed
        self.photo = photo
        self.schedule = schedule
        self.history = history
        self.amount = amount
    }
}
