//
//  User+CoreDataProperties.swift
//  CourseworkChat
//
//  Created by Admin on 06.06.2021.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var loginUser: String?
    @NSManaged public var chats: NSSet?
    @NSManaged public var contacts: NSSet?

}

// MARK: Generated accessors for chats
extension User {

    @objc(addChatsObject:)
    @NSManaged public func addToChats(_ value: Chats)

    @objc(removeChatsObject:)
    @NSManaged public func removeFromChats(_ value: Chats)

    @objc(addChats:)
    @NSManaged public func addToChats(_ values: NSSet)

    @objc(removeChats:)
    @NSManaged public func removeFromChats(_ values: NSSet)

}

// MARK: Generated accessors for contacts
extension User {

    @objc(addContactsObject:)
    @NSManaged public func addToContacts(_ value: Contacts)

    @objc(removeContactsObject:)
    @NSManaged public func removeFromContacts(_ value: Contacts)

    @objc(addContacts:)
    @NSManaged public func addToContacts(_ values: NSSet)

    @objc(removeContacts:)
    @NSManaged public func removeFromContacts(_ values: NSSet)

}

extension User : Identifiable {

}
