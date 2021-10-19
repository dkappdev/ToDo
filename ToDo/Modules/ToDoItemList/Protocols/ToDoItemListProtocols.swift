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
    
    func showToDoItemsForGroup(_ group: ToDoGroupModel)
}

// Presenter -> Wireframe
public protocol AnyToDoItemListWireframe: AnyObject {
    static func createToDoItemListModule(for group: ToDoGroupModel) -> UIViewController
    
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
    
    func requestUpdatedToDoGroup(_ group: ToDoGroupModel)
    func removeToDoItem(_ item: ToDoItemModel)
}

// Interactor -> Presenter
public protocol AnyToDoItemListInteractorOutput: AnyObject {
    func didReceiveNewToDoGroup(_ group: ToDoGroupModel)
}

public protocol AnyToDoItemListLocalDataManager: AnyObject {
    func updateToDoGroup(_ group: ToDoGroupModel) -> ToDoGroupModel
    func removeToDoItem(_ item: ToDoItemModel)
}