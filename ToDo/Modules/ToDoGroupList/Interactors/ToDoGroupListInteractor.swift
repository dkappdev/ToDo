//
//  ToDoGroupListInteractor.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 16.10.2021.
//

import Foundation

public class ToDoGroupListInteractor: AnyToDoGroupListInteractorInput {
    public var localDataManager: AnyToDoGroupListLocalDataManager?
    public weak var presenter: AnyToDoGroupListInteractorOutput?
    
    public func retrieveToDoGroupList() {
        presenter?.didRetrieveToDoGroupList(localDataManager?.retrieveToDoGroupList() ?? [])
    }
    
    public func removeToDoGroup(_ group: ToDoGroupModel) {
        localDataManager?.removeToDoGroup(group)
    }
}
