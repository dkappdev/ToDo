//
//  AddEditItemProtocols.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 20.10.2021.
//

import UIKit

// Presenter -> View
public protocol AnyAddEditItemView: AnyObject {
    var presenter: AnyAddEditItemPresenter? { get set }
    
    func showAddScreen()
    func showEditScreen(for item: ToDoItemModel)
}

// Presenter -> Wireframe
public protocol AnyAddEditItemWireframe: AnyObject {
    static func createAddEditItemModule(for item: ToDoItemModel?, inGroup group: ToDoGroupModel, with delegate: AddEditItemModuleDelegate) -> UIViewController
    
    func dismissAddEditScreen(using delegate: AddEditItemModuleDelegate?)
}

// View -> Presenter
public protocol AnyAddEditItemPresenter: AnyObject {
    var view: AnyAddEditItemView? { get set }
    var interactor: AnyAddEditItemInteractorInput? { get set }
    var wireframe: AnyAddEditItemWireframe? { get set }
    var delegate: AddEditItemModuleDelegate? { get set }
    
    func viewDidLoad()
    func dismiss()
    func saveItem(text: String, dueDate: Date?)
}

// Presenter -> Interactor
public protocol AnyAddEditItemInteractorInput: AnyObject {
    var presenter: AnyAddEditItemInteractorOutput? { get set }
    var localDataManager: AnyAddEditItemLocalDataManager? { get set }
    
    func updateItem(_ item: ToDoItemModel)
    func createNewItem(_ item: ToDoItemModel)
}

// Interactor -> Presenter
public protocol AnyAddEditItemInteractorOutput: AnyObject {
    
}

public protocol AnyAddEditItemLocalDataManager: AnyObject {
    func updateItem(_ item: ToDoItemModel)
    func createNewItem(_ item: ToDoItemModel)
}

public protocol AddEditItemModuleDelegate: AnyObject {
    func dismissAddEditScreen()
}
