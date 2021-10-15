//
//  ToDoItem+CoreDataProperties.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 15.10.2021.
//
//

import Foundation
import CoreData


extension ToDoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItem> {
        return NSFetchRequest<ToDoItem>(entityName: "ToDoItem")
    }

    @NSManaged public var dateAdded: Date?
    @NSManaged public var dueDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var text: String?
    @NSManaged public var group: ToDoGroup?

}

extension ToDoItem : Identifiable {

}
