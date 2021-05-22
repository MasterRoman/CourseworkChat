//
//  CommunicationProtocol.swift
//  CourseworkChat
//
//  Created by Admin on 22.05.2021.
//

import Foundation

enum SendReceiveProtocol : Codable{
    enum CodingKeys: CodingKey {
        case registration,authorization,newChat,newMessage,offline
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let keys = container.allKeys.first
        switch keys {
        case .registration:
            var nestedContainer = try container.nestedUnkeyedContainer(forKey: .registration)
            let login = try nestedContainer.decode(String.self)
            let password = try nestedContainer.decode(String.self)
            self = .registration(login: login, password: password)
        case .authorization:
            var nestedContainer = try container.nestedUnkeyedContainer(forKey: .authorization)
            let login = try nestedContainer.decode(String.self)
            let password = try nestedContainer.decode(String.self)
            self = .authorization(login: login,password : password)
        case .newChat:
            let chat = try container.decode(Chat.self, forKey: .newChat)
            self = .newChat(chat: chat)
        case .newMessage:
            let message = try container.decode(ChatBody.self, forKey: .newMessage)
            self = .newMessage(message: message)
        case .offline:
            let login = try container.decode(String.self, forKey: .offline)
            self = .offline(login: login)
        default:
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Unabled to decode enum."
                )
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .registration(login: let login, password: let password):
            var nestedContainer = container.nestedUnkeyedContainer(forKey: .registration)
            try nestedContainer.encode(login)
            try nestedContainer.encode(password)
        case .authorization(login: let login,password : let password):
            var nestedContainer = container.nestedUnkeyedContainer(forKey: .authorization)
            try nestedContainer.encode(login)
            try nestedContainer.encode(password)
        case .newChat(chat: let chat):
            try container.encode(chat, forKey: .newChat)
        case .newMessage(message: let message):
            try container.encode(message, forKey: .newMessage)
        case .offline(login: let login):
            try container.encode(login, forKey: .offline)
        }
    }
    
    case registration(login:String,password:String)
    case authorization(login:String,password:String)
    case newChat(chat:Chat)
    case newMessage(message:ChatBody)
    case offline(login:String)
    
}
