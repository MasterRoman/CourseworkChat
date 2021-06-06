//
//  Chats+CoreDataProperties.swift
//  CourseworkChat
//
//  Created by Admin on 06.06.2021.
//
//

import Foundation
import CoreData


extension Chats {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chats> {
        return NSFetchRequest<Chats>(entityName: "Chats")
    }

    @NSManaged public var body: Data?
    @NSManaged public var id: UUID?
    @NSManaged public var senders: Data?
    @NSManaged public var user: NSSet?

}

// MARK: Generated accessors for user
extension Chats {

    @objc(addUserObject:)
    @NSManaged public func addToUser(_ value: User)

    @objc(removeUserObject:)
    @NSManaged public func removeFromUser(_ value: User)

    @objc(addUser:)
    @NSManaged public func addToUser(_ values: NSSet)

    @objc(removeUser:)
    @NSManaged public func removeFromUser(_ values: NSSet)

}

extension Chats : Identifiable {

}
