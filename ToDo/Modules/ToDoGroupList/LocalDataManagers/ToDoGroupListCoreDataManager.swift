//
//  ToDoGroupListCoreDataManager.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 15.10.2021.
//

import Foundation
import UIKit

public class ToDoGroupListCoreDataManager: AnyToDoGroupListLocalDataManager {
    private let persistenceController = CoreDataPersistenceController.shared
    
    public func retrieveToDoGroupList() -> [ToDoGroupModel] {
        // Retrieving Core Data class instances of to-do groups
        let groupObjects = try? persistenceController.context.fetch(ToDoGroup.fetchRequest())
        guard let groupObjects = groupObjects else { return [] }
        // Converting them to general models
        return groupObjects.compactMap { $0.model() }
    }
    
    public func removeToDoGroup(_ group: ToDoGroupModel) {
        // Creating a request to fetch all groups with the same id as the one we want to remove
        let fetchRequest = ToDoGroup.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [group.id as Any])
        guard let groupsToRemove = try? persistenceController.context.fetch(fetchRequest) else { return }
        
        // Removing fetched groups
        for groupToRemove in groupsToRemove {
            persistenceController.context.delete(groupToRemove)
        }
        persistenceController.saveContext()
    }
}
