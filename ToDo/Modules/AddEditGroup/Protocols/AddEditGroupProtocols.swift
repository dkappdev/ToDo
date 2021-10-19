//
//  AddEditGroupProtocols.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 19.10.2021.
//

import UIKit

// Presenter -> View
public protocol AnyAddEditGroupView: AnyObject {
    var presenter: AnyAddEditGroupPresenter? { get set }
    
    func showAddScreen(withColorOptions colors: [UIColor])
    func showEditScreen(for group: ToDoGroupModel, withColorOptions colors: [UIColor])
}

// Presenter -> Wireframe
public protocol AnyAddEditGroupWireframe: AnyObject {
    static func createAddEditGroupModule() -> UIViewController
    
    func dismissAddEditScreen()
}

// View -> Presenter
public protocol AnyAddEditGroupPresenter: AnyObject {
    var view: AnyAddEditGroupView? { get set }
    var interactor: AnyAddEditGroupInteractorInput? { get set }
    var wireframe: AnyAddEditGroupWireframe? { get set }
    
    func viewDidLoad()
    func cancel()
    func updateGroup(_ group: ToDoGroupModel)
    func createNewGroup(_ group: ToDoGroupModel)
}

// Presenter -> Interactor
public protocol AnyAddEditGroupInteractorInput: AnyObject {
    var presenter: AnyAddEditGroupInteractorOutput? { get set }
    var localDataManager: AnyAddEditGroupLocalDataManager? { get set }
    
    func updateGroup(_ group: ToDoGroupModel)
    func createNewGroup(_ group: ToDoGroupModel)
    func retrieveColorOptions() -> [UIColor]
}

// Interactor -> Presenter
public protocol AnyAddEditGroupInteractorOutput: AnyObject {
    
}

public protocol AnyAddEditGroupLocalDataManager: AnyObject {
    func updateGroup(_ group: ToDoGroupModel)
    func createNewGroup(_ group: ToDoGroupModel)
    func retrieveColorOptions() -> [UIColor]
}

