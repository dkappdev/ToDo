//
//  ToDoItem+CoreDataClass.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 15.10.2021.
//
//

import Foundation
import CoreData

@objc(ToDoItem)
public class ToDoItem: NSManagedObject {
    /// Creates an instance of `ToDoItemModel` from Core Data class
    /// - Returns: Representation of a `ToDoItem` as a `ToDoItemModel`
    public func model() -> ToDoItemModel? {
        ToDoItemModel(dueDate: dueDate, dateAdded: dateAdded, id: id, isCompleted: isCompleted, text: text, group: group?.model())
    }
    
    /// Converts `ToDoItemModel` to Core Data class
    /// - Parameter model: an instance of `ToDoItemModel`
    public func setup(with model: ToDoItemModel) {
        dueDate = model.dueDate
        dateAdded = model.dateAdded
        id = model.id
        isCompleted = model.isCompleted
        text = model.text
        let groupObject = ToDoGroup()
        groupObject.setup(with: model.group ?? ToDoGroupModel(id: nil, color: nil, name: nil, items: nil))
        group = groupObject
    }
}
