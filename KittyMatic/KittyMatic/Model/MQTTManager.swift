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
    @Published var messages: [String : [String]] = [:]
    
    init() {
        // Configuración del cliente MQTT
        mqtt = CocoaMQTT(clientID: "iOS Device", host: "raspberrypi.local", port: 1883)
        mqtt.delegate = self
        _ = mqtt.connect()
    }
    
    func connect() {
        _ = mqtt.connect()
    }
    
    func subscribeTopic() {
        mqtt.subscribe("cantidad")  // Suscribirse al tema donde Python publica mensajes
        mqtt.subscribe("comio")
        mqtt.subscribe("comio2")
    }
    
    func disconnect() {
        mqtt.disconnect()
    }
    
    func sendMsg(onTopic: String, withMessage msg: String) {
        print("Enviamos: \(msg) a \(onTopic)")
        mqtt.publish(onTopic, withString: msg)
    }
    
    private func addMessage(_ message: String, forTopic topic: String) {
        print("Recibimos: \(message) de \(topic)")
        // Agregar mensaje al diccionario bajo su tópico correspondiente
        if messages[topic] != nil {
            messages[topic]?.append(message)
        } else {
            messages[topic] = [message]
        }
    }
}

extension MQTTManager: CocoaMQTTDelegate {
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        if let messageString = message.string {
            DispatchQueue.main.async {
                self.addMessage(messageString, forTopic: message.topic)
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
