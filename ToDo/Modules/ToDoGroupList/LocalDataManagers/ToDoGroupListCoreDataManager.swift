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
        let group = ToDoGroup(context: persistenceController.context)
        group.id = UUID()
        group.dateAdded = Date()
        group.color = .systemRed
        group.name = "Group 1"
        persistenceController.saveContext()
        
        // Retrieving Core Data class instances of to-do groups
        let fetchRequest = ToDoGroup.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ToDoGroup.name, ascending: true), NSSortDescriptor(keyPath: \ToDoGroup.dateAdded, ascending: true)]
        
        let groupObjects = try? persistenceController.context.fetch(fetchRequest)
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
