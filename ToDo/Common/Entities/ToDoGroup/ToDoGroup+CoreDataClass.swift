//
//  ToDoGroup+CoreDataClass.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 14.10.2021.
//
//

import Foundation
import CoreData

@objc(ToDoGroup)
public class ToDoGroup: NSManagedObject {
    /// Creates an instance of `ToDoGroupModel` from Core Data class
    /// - Returns: Representation of a `ToDoGroup` as a `ToDoGroupModel`
    public func model() -> ToDoGroupModel? {
        ToDoGroupModel(id: id, color: color, name: name, items: items?.array as? [ToDoItemModel])
    }
}
