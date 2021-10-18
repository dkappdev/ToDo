//
//  ToDoItemListCoreDataManager.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 18.10.2021.
//

import Foundation
import CoreData

public class ToDoItemListCoreDataManager: AnyToDoItemListLocalDataManager {
    
    private let persistenceController = CoreDataPersistenceController.shared
    
    public func updateToDoGroup(_ group: ToDoGroupModel) -> ToDoGroupModel {
        // Fetching group
        let fetchRequest = ToDoGroup.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [group.id as Any])
        let groupObjects = try? persistenceController.context.fetch(fetchRequest)
        
        // Making sure only one group was fetched, then converting the group to a group model
        guard groupObjects?.count == 1,
              let groupObject = groupObjects?.first,
              let group = groupObject.model() else { return group }
        
        return group
    }
    
    public func removeToDoItem(_ item: ToDoItemModel) {
        // Creating a request to fetch all items with the same id as the one we want to remove
        let fetchRequest = ToDoItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [item.id as Any])
        guard let itemsToRemove = try? persistenceController.context.fetch(fetchRequest) else { return }
        
        for itemToRemove in itemsToRemove {
            persistenceController.context.delete(itemToRemove)
        }
        persistenceController.saveContext()
    }
}
