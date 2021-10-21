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
        // Fetching item
        let fetchRequest = ToDoItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [item.id as Any])
        let itemObjects = try? persistenceController.context.fetch(fetchRequest)
        
        // Making sure an item instance already exists
        guard itemObjects?.count == 1,
              let itemObject = itemObjects?.first else {
                  print("Unable to update item record. No previous version found in database.")
                  return
              }
        
        // Updating item info
        itemObject.setup(with: item)
        
        persistenceController.saveContext()
    }
    
    public func createNewItem(_ item: ToDoItemModel) {
        // Attempting to fetch item to make sure it was not previously saved
        let fetchRequest = ToDoItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [item.id as Any])
        let itemObjects = try? persistenceController.context.fetch(fetchRequest)
        
        guard itemObjects?.count == 0 else {
            print("Unable to create a new item record. The item was already saved to the database. Update existing record instread.")
            return
        }
        
        // Creating new item object
        let itemObject = ToDoItem(context: persistenceController.context)
        itemObject.setup(with: item)
        
        persistenceController.saveContext()
    }
}
