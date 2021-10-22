//
//  AddEditItemCoreDataManager.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 21.10.2021.
//

import Foundation

public class AddEditItemCoreDataManager: AnyAddEditItemLocalDataManager {
    
    private let persistenceController = CoreDataPersistenceController.shared
    
    public func updateItem(_ item: ToDoItemModel) {
        guard let group = item.group else {
            print("Unable to update item - invalid model")
            return
        }
        // Fetching item
        let itemFetchRequest = ToDoItem.fetchRequest()
        itemFetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [item.id as Any])
        let itemObjects = try? persistenceController.context.fetch(itemFetchRequest)
        
        // Fetching group containing item
        let groupFetchRequest = ToDoGroup.fetchRequest()
        groupFetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [group.id as Any])
        let groupObjects = try? persistenceController.context.fetch(groupFetchRequest)
        
        // Making sure an item instance already exists
        guard itemObjects?.count == 1,
              groupObjects?.count == 1,
              let itemObject = itemObjects?.first,
              let groupObject = groupObjects?.first else {
                  print("Unable to update item record. No previous version found in database.")
                  return
              }
        
        // Updating item info
        itemObject.setup(with: item)
        groupObject.addToItems(itemObject)
        
        persistenceController.saveContext()
    }
    
    public func createNewItem(_ item: ToDoItemModel) {
        guard let group = item.group else {
            print("Unable to update item - invalid model")
            return
        }
        
        // Attempting to fetch item to make sure it was not previously saved
        let itemFetchRequest = ToDoItem.fetchRequest()
        itemFetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [item.id as Any])
        let itemObjects = try? persistenceController.context.fetch(itemFetchRequest)
        
        // Fetching group containing item
        let groupFetchRequest = ToDoGroup.fetchRequest()
        groupFetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [group.id as Any])
        let groupObjects = try? persistenceController.context.fetch(groupFetchRequest)
        
        guard itemObjects?.count == 0 else {
            print("Unable to create a new item record. The item was already saved to the database. Update existing record instead.")
            return
        }
        
        guard groupObjects?.count == 1,
              let groupObject = groupObjects?.first else {
                  print("Unable to create a new item record. Failed to retrieve group that contains the item.")
                  return
              }
        
        // Creating new item object
        let itemObject = ToDoItem(context: persistenceController.context)
        itemObject.setup(with: item)
        groupObject.addToItems(itemObject)
        
        persistenceController.saveContext()
    }
}
