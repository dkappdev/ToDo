//
//  ToDoItemListProtocols.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 17.10.2021.
//

import UIKit

// Presenter -> View
public protocol AnyToDoItemListView: AnyObject {
    var presenter: AnyToDoItemListPresenter? { get set }
    
    func showToDoItems(_ items: [ToDoItemModel])
}

// Presenter -> Wireframe
public protocol AnyToDoItemListWireframe: AnyObject {
    static func createToDoItemListModule() -> UIViewController
    
    func presentAddItemScreen()
    func presentEditItemScreen(for item: ToDoItemModel)
}

// View -> Presenter
public protocol AnyToDoItemListPresenter: AnyObject {
    var view: AnyToDoItemListView? { get set }
    var interactor: AnyToDoItemListInteractorInput? { get set }
    var wireframe: AnyToDoItemListWireframe? { get set }
    
    func viewDidLoad()
    func addItem()
    func editItem(_ item: ToDoItemModel)
    func deleteItem(_ item: ToDoItemModel)
}

// Presenter -> Interactor
public protocol AnyToDoItemListInteractorInput: AnyObject {
    var presenter: AnyToDoItemListInteractorOutput? { get set }
    var localDataManager: AnyToDoItemListLocalDataManager? { get set }
    
    func retrieveToDoItemList(for group: ToDoGroupModel)
    func removeToDoItem(_ item: ToDoItemModel, from group: ToDoGroupModel)
}

// Interactor -> Presenter
public protocol AnyToDoItemListInteractorOutput: AnyObject {
    func didRetrieveToDoItemList(_ itemList: [ToDoItemModel])
}

public protocol AnyToDoItemListLocalDataManager: AnyObject {
    func retrieveToDoItemList() -> [ToDoItemModel]
    func removeToDoItem(_ item: ToDoItemModel, from group: ToDoGroupModel)
}
