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
    public var uuid: UUID?
    /// Indicates whether or not to-do item is marked as complete
    public var isCompleted: Bool = false
    /// Text describing the to-do task
    public var text: String?
    /// Group that contains the item
    public weak var group: ToDoGroup?
}
