//
//  ToDoItemListInteractor.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 18.10.2021.
//

import Foundation

public class ToDoItemListInteractor: AnyToDoItemListInteractorInput {
    
    public weak var presenter: AnyToDoItemListInteractorOutput?
    public var localDataManager: AnyToDoItemListLocalDataManager?
    
    public func requestUpdatedToDoGroup(_ group: ToDoGroupModel) {
        presenter?.didReceiveNewToDoGroup(localDataManager?.updateToDoGroup(group) ?? group)
    }
    
    public func removeToDoItem(_ item: ToDoItemModel) {
        localDataManager?.removeToDoItem(item)
        
        // Removing all pending notifications
        item.dueDate = nil
        item.updateNotifications()
    }
    
    public func toggleCompleted(for item: ToDoItemModel, isCompleted: Bool) {
        item.isCompleted = isCompleted
        item.updateNotifications()
        localDataManager?.toggleCompleted(for: item, isCompleted: isCompleted)
    }
}
