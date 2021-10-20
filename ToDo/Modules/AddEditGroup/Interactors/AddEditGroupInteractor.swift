//
//  AddEditGroupInteractor.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 19.10.2021.
//

import UIKit

public class AddEditGroupInteractor: AnyAddEditGroupInteractorInput {
    public weak var presenter: AnyAddEditGroupInteractorOutput?
    public var localDataManager: AnyAddEditGroupLocalDataManager?
    
    public func updateGroup(_ group: ToDoGroupModel) {
        localDataManager?.updateGroup(group)
    }
    
    public func createNewGroup(_ group: ToDoGroupModel) {
        localDataManager?.createNewGroup(group)
    }
    
    public func retrieveColorOptions() -> [UIColor] {
        return localDataManager?.retrieveColorOptions() ?? []
    }
    
    
}
