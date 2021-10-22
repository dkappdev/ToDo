//
//  AddEditItemInteractor.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 21.10.2021.
//

import Foundation

public class AddEditItemInteractor: AnyAddEditItemInteractorInput {
    public weak var presenter: AnyAddEditItemInteractorOutput?
    public var localDataManager: AnyAddEditItemLocalDataManager?
    
    public func updateItem(_ item: ToDoItemModel) {
        localDataManager?.updateItem(item)
    }
    
    public func createNewItem(_ item: ToDoItemModel) {
        localDataManager?.createNewItem(item)
    }
}
