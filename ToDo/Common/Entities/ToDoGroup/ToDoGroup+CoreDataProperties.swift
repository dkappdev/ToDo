//
//  ToDoGroup+CoreDataProperties.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 14.10.2021.
//
//

import Foundation
import UIKit
import CoreData


extension ToDoGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoGroup> {
        return NSFetchRequest<ToDoGroup>(entityName: "ToDoGroup")
    }

    @NSManaged public var uuid: UUID?
    @NSManaged public var color: UIColor?
    @NSManaged public var name: String?
    @NSManaged public var items: NSOrderedSet?

}

// MARK: Generated accessors for items
extension ToDoGroup {

    @objc(insertObject:inItemsAtIndex:)
    @NSManaged public func insertIntoItems(_ value: ToDoItem, at idx: Int)

    @objc(removeObjectFromItemsAtIndex:)
    @NSManaged public func removeFromItems(at idx: Int)

    @objc(insertItems:atIndexes:)
    @NSManaged public func insertIntoItems(_ values: [ToDoItem], at indexes: NSIndexSet)

    @objc(removeItemsAtIndexes:)
    @NSManaged public func removeFromItems(at indexes: NSIndexSet)

    @objc(replaceObjectInItemsAtIndex:withObject:)
    @NSManaged public func replaceItems(at idx: Int, with value: ToDoItem)

    @objc(replaceItemsAtIndexes:withItems:)
    @NSManaged public func replaceItems(at indexes: NSIndexSet, with values: [ToDoItem])

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: ToDoItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: ToDoItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSOrderedSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSOrderedSet)

}

extension ToDoGroup : Identifiable {

}
