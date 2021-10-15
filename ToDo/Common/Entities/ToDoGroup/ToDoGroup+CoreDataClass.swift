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
        let sortDescriptor = NSSortDescriptor(keyPath: \ToDoGroup.name, ascending: true)
        let items = items?.sortedArray(using: [sortDescriptor]) as? [ToDoItem]
        
        guard let items = items else { return nil }
        let itemModels = items.compactMap { $0.model() }
        
        return ToDoGroupModel(id: id, color: color, name: name, items: itemModels)
    }
    
    /// Converts `ToDoGroupModel` to Core Data class
    /// - Parameter model: an instance of `ToDoGroupModel`
    public func setup(with model: ToDoGroupModel) {
        id = model.id
        color = model.color
        name = model.name
        items = NSSet(array: model.items ?? [])
    }
}
