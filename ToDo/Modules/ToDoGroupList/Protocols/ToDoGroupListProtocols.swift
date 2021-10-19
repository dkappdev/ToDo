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
    
    func presentToDoItemList(for group: ToDoGroupModel, from view: UIViewController)
    func presentAddGroupModule(withDelegate delegate: AddEditGroupModuleDelegate, from view: UIViewController)
    func presentEditGroupModule(for group: ToDoGroupModel, withDelegate: AddEditGroupModuleDelegate, from view: UIViewController)
    func dismissAddEditModule(parent: UIViewController)
}

// View -> Presenter
public protocol AnyToDoGroupListPresenter: AnyObject {
    var view: AnyToDoGroupListView? { get set }
    var interactor: AnyToDoGroupListInteractorInput? { get set }
    var wireframe: AnyToDoGroupListWireframe? { get set }
    
    func viewDidLoad()
    func addGroup()
    func editGroup(_ group: ToDoGroupModel)
    func deleteGroup(_ group: ToDoGroupModel)
    func showToDoItemList(for group: ToDoGroupModel)
}

// Presenter -> Interactor
public protocol AnyToDoGroupListInteractorInput: AnyObject {
    var presenter: AnyToDoGroupListInteractorOutput? { get set }
    var localDataManager: AnyToDoGroupListLocalDataManager? { get set }
    
    func retrieveToDoGroupList()
    func removeToDoGroup(_ group: ToDoGroupModel)
}

// Interactor -> Presenter
public protocol AnyToDoGroupListInteractorOutput: AnyObject {
    func didRetrieveToDoGroupList(_ groupList: [ToDoGroupModel])
}

public protocol AnyToDoGroupListLocalDataManager: AnyObject {
    func retrieveToDoGroupList() -> [ToDoGroupModel]
    func removeToDoGroup(_ group: ToDoGroupModel)
}
