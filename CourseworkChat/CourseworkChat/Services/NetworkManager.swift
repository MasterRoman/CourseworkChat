//
//  NetworkManager.swift
//  CourseworkChat
//
//  Created by Admin on 22.05.2021.
//

import Foundation
import BSDSocketWrapper

protocol NetworkClient {
    func start()throws ->Bool
    func stop()throws ->Bool
    func send(message : SendReceiveProtocol) throws
    func receive(complationHandler:(Result<SendReceiveProtocol,Error>) -> (Void)) throws
}

class NetworkManager : NetworkClient{
    var address : String
    var port : String
    
    let socket : ClientEndpoint
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    init(with address : String = "192.168.78.132",port : String = "2784") throws {
        self.address = address
        self.port = port
        self.socket = try ClientEndpoint(host: address, port: port, sockType: .stream)
    }
    
    func start() -> Bool{
        do {
            try socket.connect()
        } catch (_) {
            return false
        }
        return true
    }
    
    func stop() -> Bool{
        do {
            try socket.shutdown(with: .shutBoth)
            try socket.close()
        } catch (_) {
            return false
        }
        return true
    }
    
    func send(message : SendReceiveProtocol) throws{
        let data = try encoder.encode(message)
        try socket.send(data: data)
    }
    
    func receive(complationHandler:(Result<SendReceiveProtocol,Error>) -> (Void)) throws {
        try socket.receive({ data in
            var result : SendReceiveProtocol
            do {
                result = try decoder.decode(SendReceiveProtocol.self, from: data)
                complationHandler(.success(result))
            } catch (let error) {
                complationHandler(.failure(error))
            }
        })
        
    }
}
