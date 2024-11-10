//
//  MQTTManager.swift
//  KittyMatic
//
//  Created by Diego Ignacio Nunez Hernandez on 06/11/24.
//

import Foundation
import CocoaMQTT

class MQTTManager: ObservableObject {
    private var mqtt: CocoaMQTT!
    @Published var messages: [String] = []

    init() {
        // Configuración del cliente MQTT
        mqtt = CocoaMQTT(clientID: "iOS Device", host: "raspberrypi.local", port: 1883)
        mqtt.delegate = self
        mqtt.connect()
    }

    func subscribeTopic() {
        mqtt.subscribe("test")  // Suscribirse al tema donde Python publica mensajes
    }
    
    func disconnect() {
        mqtt.disconnect()
    }
    
    func sendMsg(_ msg: String) {
        mqtt.publish("rpi", withString: msg)
    }
}

extension MQTTManager: CocoaMQTTDelegate {
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        if let messageString = message.string {
            DispatchQueue.main.async {
                self.messages.append("Recibido: \(messageString)")
            }
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        if ack == .accept {
            print("Conectado al servidor MQTT")
            subscribeTopic()
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didDisconnectWithError err: Error?) {
        print("Desconectado: \(err?.localizedDescription ?? "Sin error")")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        //
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        //
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
        //
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        //
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        //
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: (any Error)?) {
        //
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        //
    }
}
