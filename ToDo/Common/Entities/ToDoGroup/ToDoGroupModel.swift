//
//  ToDoGroupModel.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 14.10.2021.
//

import Foundation
import UIKit

public class ToDoGroupModel {
    /// Unique group identifier
    public var id: UUID?
    /// Group color
    public var color: UIColor?
    /// Group names
    public var name: String?
    /// To-do items for the groups
    public var items: [ToDoItemModel]?
    
    public init(id: UUID?, color: UIColor?, name: String?, items: [ToDoItemModel]?) {
        self.id = id
        self.color = color
        self.name = name
        self.items = items
    }
}

extension ToDoGroupModel: Hashable {
    public static func == (lhs: ToDoGroupModel, rhs: ToDoGroupModel) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
