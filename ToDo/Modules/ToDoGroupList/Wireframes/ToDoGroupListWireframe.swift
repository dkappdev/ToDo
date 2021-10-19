//
//  ToDoGroupListWireframe.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 16.10.2021.
//

import UIKit

public class ToDoGroupListWireframe: AnyToDoGroupListWireframe {
    public static func createToDoGroupListModule() -> UIViewController {
        let view: AnyToDoGroupListView & UIViewController = ToDoGroupListView()
        let presenter: AnyToDoGroupListPresenter & AnyToDoGroupListInteractorOutput = ToDoGroupListPresenter()
        let interactor: AnyToDoGroupListInteractorInput = ToDoGroupListInteractor()
        let localDataManager: AnyToDoGroupListLocalDataManager = ToDoGroupListCoreDataManager()
        let wireframe: AnyToDoGroupListWireframe = ToDoGroupListWireframe()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.wireframe = wireframe
        presenter.interactor = interactor
        
        interactor.presenter = presenter
        interactor.localDataManager = localDataManager
        
        return UINavigationController(rootViewController: view)
    }
    
    public func presentToDoItemList(for group: ToDoGroupModel, from view: UIViewController) {
        let toDoItemListModule = ToDoItemListWireframe.createToDoItemListModule(for: group)
        if let navigationController = view.navigationController {
            navigationController.pushViewController(toDoItemListModule, animated: true)
        } else {
            view.present(toDoItemListModule, animated: true, completion: nil)
        }
    }
    
    public func presentAddGroupModule(withDelegate delegate: AddEditGroupModuleDelegate) {
        assertionFailure("presentAddGroupScreen() has not yet been implemented")
    }
    
    public func presentEditGroupModule(for group: ToDoGroupModel, withDelegate delegate: AddEditGroupModuleDelegate) {
        assertionFailure("presentEditGroupScreen(for:) has not yet been implemented")
    }
    
    public func dismissAddEditModule(parent: UIViewController) {
        parent.dismiss(animated: true, completion: nil)
    }
}
