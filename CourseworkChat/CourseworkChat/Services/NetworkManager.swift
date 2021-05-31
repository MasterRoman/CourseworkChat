//
//  NetworkManager.swift
//  CourseworkChat
//
//  Created by Admin on 22.05.2021.
//

import Foundation
import BSDSocketWrapper

protocol NetworkClient {
    func send(message : SendReceiveProtocol) throws
}

class NetworkManager : NetworkClient {
    
    let socket : ClientEndpoint
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    init(with address : String = "192.168.78.132",port : String = "2786") throws {
        self.socket = try ClientEndpoint(host: address, port: port, sockType: .stream)
        do {
            try socket.connect()
            try recieveUntillOffline()
        } catch (_) {
            try socket.close()
        }
    }
    
    func recieveUntillOffline() throws{
        DispatchQueue.global(qos: .utility).async{ [weak self] in
            guard let self = self else {return}
            while true {
                do{
                    try self.socket.receive({ data in
                        var result : SendReceiveProtocol
                        do {
                            result = try self.decoder.decode(SendReceiveProtocol.self, from: data)
                            switch result{
                            case .checkLogin(login: let login):
                                NotificationCenter.default.post(name: .checkLogin, object: login)
                            case .registration(credentials : let credentials):
                                NotificationCenter.default.post(name: .registration, object: credentials)
                            case .authorization(credentials : let credentials):
                                NotificationCenter.default.post(name: .authorization, object: credentials)
                            case .newChat(chat: let chat):
                                NotificationCenter.default.post(name: .newChat, object: chat)
                            case .newMessage(message: let message):
                                NotificationCenter.default.post(name: .newMessage, object: message)
                            case .newContact(login: let login):
                                NotificationCenter.default.post(name: .newContact, object: login)
                            case .offline(login: let login):
                                NotificationCenter.default.post(name: .offline, object: login)
                            }
                            
                        } catch (_) {
                        
                        }
                    })
                }
                catch{
                    return
                }
            }
        }
    }
    
    
    func send(message : SendReceiveProtocol) throws{
        let data = try encoder.encode(message)
        try socket.send(data: data)
    }
    
    
    deinit {
        do{
            try socket.shutdown(with: .shutBoth)
            try socket.close()
        }
        catch (let error)
        {
            print(error)
        }
    }
    
    
}
