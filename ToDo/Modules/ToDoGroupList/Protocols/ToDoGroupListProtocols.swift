//
//  ToDoGroupListProtocols.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 14.10.2021.
//

import UIKit

// Presenter -> View
public protocol AnyToDoGroupListView: AnyObject {
    var presenter: AnyToDoGroupListPresenter? { get set }
    
    func showToDoGroups(_ groups: [ToDoGroupModel])
}

// Presenter -> Wireframe
public protocol AnyToDoGroupListWireframe: AnyObject {
    static func createToDoGroupListModule() -> UIViewController
    
    func presentToDoItemList(for group: ToDoGroupModel)
    func presentEditGroupScreen(for group: ToDoGroupModel)
}

// View -> Presenter
public protocol AnyToDoGroupListPresenter: AnyObject {
    var view: AnyToDoGroupListView? { get set }
    var interactor: AnyToDoGroupListInteractorInput? { get set }
    var wireframe: AnyToDoGroupListWireframe? { get set }
    
    func viewDidLoad()
    func editGroup(_ group: ToDoGroupModel)
    func deleteGroup(_ group: ToDoGroupModel)
    func showToDoItemList(for group: ToDoGroupModel)
}

// Presenter -> Interactor
public protocol AnyToDoGroupListInteractorInput: AnyObject {
    var presenter: AnyToDoGroupListPresenter? { get set }
    
    func retrieveToDoGroupList()
}

// Interactor -> Presenter
public protocol AnyToDoGroupListInteractorOutput: AnyObject {
    func didRetrieveToDoGroupList(_ groupList: [ToDoGroupModel])
}

public protocol AnyToDoGroupListLocalDataManager: AnyObject {
    func retrieveToDoGroupList() -> [ToDoGroupModel]
    func removeToDoGroup(_ group: ToDoGroupModel)
}
