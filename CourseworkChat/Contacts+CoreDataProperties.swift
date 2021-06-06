//
//  Contacts+CoreDataProperties.swift
//  CourseworkChat
//
//  Created by Admin on 06.06.2021.
//
//

import Foundation
import CoreData


extension Contacts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contacts> {
        return NSFetchRequest<Contacts>(entityName: "Contacts")
    }

    @NSManaged public var login: String?
    @NSManaged public var user: NSSet?

}

// MARK: Generated accessors for user
extension Contacts {

    @objc(addUserObject:)
    @NSManaged public func addToUser(_ value: User)

    @objc(removeUserObject:)
    @NSManaged public func removeFromUser(_ value: User)

    @objc(addUser:)
    @NSManaged public func addToUser(_ values: NSSet)

    @objc(removeUser:)
    @NSManaged public func removeFromUser(_ values: NSSet)

}

extension Contacts : Identifiable {

}
