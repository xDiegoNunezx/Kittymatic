//
//  KittyMaticApp.swift
//  KittyMatic
//
//  Created by Diego Ignacio Nunez Hernandez on 06/11/24.
//

import SwiftUI

@main
struct KittyMaticApp: App {
    @StateObject private var mqttManager = MQTTManager()
    @StateObject private var viewModel = CatViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(mqttManager)
                .environmentObject(viewModel)
        }
    }
}
