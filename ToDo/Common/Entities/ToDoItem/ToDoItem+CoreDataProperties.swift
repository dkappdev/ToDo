//
//  ToDoItem+CoreDataProperties.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 14.10.2021.
//
//

import Foundation
import CoreData


extension ToDoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItem> {
        return NSFetchRequest<ToDoItem>(entityName: "ToDoItem")
    }

    @NSManaged public var dueDate: Date?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var uuid: UUID?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var text: String?

}

extension ToDoItem : Identifiable {

}
