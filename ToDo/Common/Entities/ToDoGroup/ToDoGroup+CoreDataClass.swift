//
//  ToDoGroup+CoreDataClass.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 15.10.2021.
//
//

import Foundation
import UIKit
import CoreData

@objc(ToDoGroup)
public class ToDoGroup: NSManagedObject {
    /// Creates an instance of `ToDoGroupModel` from Core Data class
    /// - Returns: Representation of a `ToDoGroup` as a `ToDoGroupModel`
    public func model() -> ToDoGroupModel? {
        let sortDescriptors = [NSSortDescriptor(keyPath: \ToDoItem.isCompleted, ascending: true), NSSortDescriptor(keyPath: \ToDoItem.dueDate, ascending: true), NSSortDescriptor(keyPath: \ToDoItem.dateAdded, ascending: true)]
        let items = items?.sortedArray(using: sortDescriptors) as? [ToDoItem]
        
        guard let items = items else { return nil }
        let itemModels = items.compactMap { $0.model() }
        
        let model = ToDoGroupModel(id: id, color: color, name: name, items: itemModels)
        
        return model
    }
    
    /// Converts `ToDoGroupModel` to Core Data class
    /// - Parameter model: an instance of `ToDoGroupModel`
    public func setup(with model: ToDoGroupModel) {
        id = model.id
        color = model.color
        name = model.name
    }
}
