//
//  ToDoItemModel.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 14.10.2021.
//

import Foundation

public class ToDoItemModel {
    /// Due date for item
    public var dueDate: Date?
    /// Date when the item was added
    public var dateAdded: Date?
    /// Unique item identifier
    public var id: UUID?
    /// Indicates whether or not to-do item is marked as complete
    public var isCompleted: Bool = false
    /// Text describing the to-do task
    public var text: String?
    /// Group that contains the item
    public weak var group: ToDoGroup?
    
    public init(dueDate: Date?, dateAdded: Date?, id: UUID?, isCompleted: Bool, text: String?, group: ToDoGroup?) {
        self.dueDate = dueDate
        self.dateAdded = dateAdded
        self.id = id
        self.isCompleted = isCompleted
        self.text = text
        self.group = group
    }
}

extension ToDoItemModel: Hashable {
    public static func == (lhs: ToDoItemModel, rhs: ToDoItemModel) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
