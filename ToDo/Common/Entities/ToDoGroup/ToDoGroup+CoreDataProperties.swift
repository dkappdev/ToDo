//
//  ToDoGroup+CoreDataProperties.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 15.10.2021.
//
//

import Foundation
import CoreData
import UIKit

extension ToDoGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoGroup> {
        return NSFetchRequest<ToDoGroup>(entityName: "ToDoGroup")
    }

    @NSManaged public var color: UIColor?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension ToDoGroup {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: ToDoItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: ToDoItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension ToDoGroup : Identifiable {

}
