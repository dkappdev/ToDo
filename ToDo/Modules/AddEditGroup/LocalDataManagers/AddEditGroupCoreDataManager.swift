//
//  AddEditGroupCoreDataManager.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 19.10.2021.
//

import UIKit

public class AddEditGroupCoreDataManager: AnyAddEditGroupLocalDataManager {
    
    private let persistenceController = CoreDataPersistenceController.shared
    
    public func updateGroup(_ group: ToDoGroupModel) {
        // Fetching group
        let fetchRequest = ToDoGroup.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [group.id as Any])
        let groupObjects = try? persistenceController.context.fetch(fetchRequest)
        
        // Making sure group already exists in context
        guard groupObjects?.count == 1,
              let groupObject = groupObjects?.first else {
                  print("Unable to update group record. No previous version found in database.")
                  return
              }
        
        // Updating group info
        groupObject.setup(with: group)
        
        persistenceController.saveContext()
    }
    
    public func createNewGroup(_ group: ToDoGroupModel) {
        // Attempting to fetch group to make sure it was not previously saved
        let fetchRequest = ToDoGroup.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [group.id as Any])
        let groupObjects = try? persistenceController.context.fetch(fetchRequest)
        
        guard groupObjects?.count == 0 else {
            print("Unable to create a new group record. The group was already saved to the database. Update existing record instead.")
            return
        }
        
        // Creating a new group object
        let groupObject = ToDoGroup(context: persistenceController.context)
        groupObject.setup(with: group)
        
        persistenceController.saveContext()
    }
    
    public func retrieveColorOptions() -> [UIColor] {
        [.systemRed, .systemOrange, .systemYellow, .systemGreen, .systemBlue, .systemPurple, .systemPink, .systemMint, .systemCyan, .systemIndigo]
    }
}
