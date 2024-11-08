//
//  ContentView.swift
//  KittyMatic
//
//  Created by Diego Ignacio Nunez Hernandez on 06/11/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CatViewModel()
    
    var body: some View {
        if viewModel.cat == nil {
            CatFeederFormView(viewModel: viewModel)
        } else {
            CatFeederView(viewModel: viewModel)
        }
    }
}

#Preview {
    ContentView()
}
