//
//  ToDoGroupListPresenter.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 16.10.2021.
//

import Foundation
import UIKit

public class ToDoGroupListPresenter: AnyToDoGroupListPresenter {
    public weak var view: AnyToDoGroupListView?
    public var interactor: AnyToDoGroupListInteractorInput?
    public var wireframe: AnyToDoGroupListWireframe?
    
    public func viewDidLoad() {
        interactor?.retrieveToDoGroupList()
    }
    
    public func editGroup(_ group: ToDoGroupModel) {
        wireframe?.presentEditGroupScreen(for: group)
    }
    
    public func deleteGroup(_ group: ToDoGroupModel) {
        interactor?.removeToDoGroup(group)
    }
    
    public func showToDoItemList(for group: ToDoGroupModel) {
        wireframe?.presentToDoItemList(for: group, from: view as? UIViewController ?? UIViewController())
    }
    
    public func addGroup() {
        wireframe?.presentAddGroupScreen()
    }
}

extension ToDoGroupListPresenter: AnyToDoGroupListInteractorOutput {
    public func didRetrieveToDoGroupList(_ groupList: [ToDoGroupModel]) {
        view?.showToDoGroups(groupList)
    }
}