//
//  ContentView.swift
//  KittyMatic
//
//  Created by Diego Ignacio Nunez Hernandez on 06/11/24.
//

import SwiftUI
import CocoaMQTT


struct ContentView: View {
    @EnvironmentObject var viewModel: CatViewModel
    var body: some View {
        //        Button("Conectar") {
        //            mqttManager.subscribeTopic()
        //        }
        //        .padding()
        //
        //        Button("Desonectar") {
        //            mqttManager.disconnect()
        //        }
        //        .padding()
        //
        //        Button("Enviar on") {
        //            //mqttClientt.publish("rpi", withString: "on", properties: MqttPublishProperties())
        //            mqttManager.sendMsg("on")
        //        }
        //        .padding()
        //
        //        Button("Enviar off") {
        //            //mqttClientt.publish("rpi", withString: "off", properties: MqttPublishProperties())
        //            mqttManager.sendMsg("on")
        //        }
        //        .padding()
        //
        //        Text("Mensajes Recibidos")
        //            .font(.headline)
        //            .padding()
        //        List(mqttManager.messages, id: \.self) { message in
        //            Text(message)
        //        }
        
        if viewModel.cat == nil {
            CatFeederFormView()
        } else {
            CatFeederView()
        }
    }
}

#Preview {
    ContentView()
}
