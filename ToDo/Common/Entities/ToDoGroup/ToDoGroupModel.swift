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
    public var uuid: UUID?
    /// Group color
    public var color: UIColor?
    /// Group names
    public var name: String?
    /// To-do items for the groups
    public var items: [ToDoItemModel]?
}
