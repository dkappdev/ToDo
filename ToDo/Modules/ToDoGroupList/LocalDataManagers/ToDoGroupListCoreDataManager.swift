//
//  ToDoGroupListCoreDataManager.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 15.10.2021.
//

import Foundation
import UIKit

public class ToDoGroupListCoreDataManager: AnyToDoGroupListLocalDataManager {
    private let delegate = (UIApplication.shared.delegate as? AppDelegate)
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func retrieveToDoGroupList() -> [ToDoGroupModel] {
        do {
            let groupObjects = try context?.fetch(ToDoGroup.fetchRequest())
            guard let groupObjects = groupObjects else { return [] }
            return groupObjects.compactMap { $0.model() }
        } catch {
            return []
        }
    }
    
    func removeToDoGroup(_ group: ToDoGroupModel) {
        // Creating a core data class instance for to-do group
        let groupObject = ToDoGroup()
        groupObject.setup(with: group)
        
        // Deleting it from context
        context?.delete(groupObject)
        delegate?.saveContext()
    }
}
