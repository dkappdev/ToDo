//
//  ToDoGroupListCoreDataManager.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 15.10.2021.
//

import Foundation
import UIKit

public class ToDoGroupListCoreDataManager: AnyToDoGroupListLocalDataManager {
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    public func retrieveToDoGroupList() -> [ToDoGroupModel] {
        // Retrieving Core Data class instances of to-do groups
        let groupObjects = try? context?.fetch(ToDoGroup.fetchRequest())
        guard let groupObjects = groupObjects else { return [] }
        // Converting them to general models
        return groupObjects.compactMap { $0.model() }
    }
    
    public func removeToDoGroup(_ group: ToDoGroupModel) {
        // Creating a request to fetch all groups with the same id as the one we want to remove
        let fetchRequest = ToDoGroup.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: [\ToDoGroup.id, group.id as Any])
        guard let groupsToRemove = try? context?.fetch(fetchRequest) else { return }
        
        // Removing fetched groups
        for groupToRemove in groupsToRemove {
            context?.delete(groupToRemove)
        }
        appDelegate?.saveContext()
    }
}
