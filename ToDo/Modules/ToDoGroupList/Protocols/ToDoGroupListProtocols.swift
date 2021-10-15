//
//  ToDoGroupListProtocols.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 14.10.2021.
//

import UIKit

// Presenter -> View
protocol AnyToDoGroupListView: AnyObject {
    var presenter: AnyToDoGroupListPresenter? { get set }
    
    func showToDoGroups(_ groups: [ToDoGroupModel])
}

// Presenter -> Wireframe
protocol AnyToDoGroupListWireframe: AnyObject {
    static func createToDoGroupListModule() -> UIViewController
    
    func presentToDoItemList(for group: ToDoGroupModel)
    func presentEditGroupScreen(for group: ToDoGroupModel)
}

// View -> Presenter
protocol AnyToDoGroupListPresenter: AnyObject {
    var view: AnyToDoGroupListView? { get set }
    var interactor: AnyToDoGroupListInteractorInput? { get set }
    var wireframe: AnyToDoGroupListWireframe? { get set }
    
    func viewDidLoad()
    func editGroup(_ group: ToDoGroupModel)
    func showToDoItemList(for group: ToDoGroupModel)
}

// Presenter -> Interactor
protocol AnyToDoGroupListInteractorInput: AnyObject {
    var presenter: AnyToDoGroupListPresenter? { get set }
    
    func retrieveToDoGroupList()
}

// Interactor -> Presenter
protocol AnyToDoGroupListInteractorOutput: AnyObject {
    func didRetrieveToDoGroupList(_ groupList: [ToDoGroupModel])
}

protocol AnyToDoGroupListLocalDataManager: AnyObject {
    func retrieveToDoGroupList() -> [ToDoGroupModel]
    func removeToDoGroup(_ group: ToDoGroupModel)
}
