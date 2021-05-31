//
//  NotificationExtensions.swift
//  CourseworkChat
//
//  Created by Admin on 23.05.2021.
//

import Foundation

extension Notification.Name{
    static let checkLogin = Notification.Name("checkLogin")
    static let registration = Notification.Name("registration")
    static let authorization = Notification.Name("authorization")
    static let newChat = Notification.Name("newChat")
    static let newMessage = Notification.Name("newMessage")
    static let newContact = Notification.Name("newContact")
    static let offline = Notification.Name("offline")
}

