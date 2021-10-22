//
//  ToDoItemListWireframe.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 18.10.2021.
//

import UIKit

public class ToDoItemListWireframe: AnyToDoItemListWireframe {
    
    public static func createToDoItemListModule(for group: ToDoGroupModel) -> UIViewController {
        let view: AnyToDoItemListView & UIViewController = ToDoItemListView()
        let presenter: AnyToDoItemListPresenter & AnyToDoItemListInteractorOutput = ToDoItemListPresenter(group: group)
        let interactor: AnyToDoItemListInteractorInput = ToDoItemListInteractor()
        let localDataManager: AnyToDoItemListLocalDataManager = ToDoItemListCoreDataManager()
        let wireframe: AnyToDoItemListWireframe = ToDoItemListWireframe()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.wireframe = wireframe
        presenter.interactor = interactor
        
        interactor.presenter = presenter
        interactor.localDataManager = localDataManager
        
        return view
    }

    public func presentAddItemModule(forItemInGroup group: ToDoGroupModel, withDelegate delegate: AddEditItemModuleDelegate, from view: UIViewController) {
        let addEditItemModule = AddEditItemWireframe.createAddEditItemModule(for: nil, inGroup: group, with: delegate)
        view.present(addEditItemModule, animated: true, completion: nil)
    }
    
    public func presentEditItemModule(for item: ToDoItemModel, in group: ToDoGroupModel, withDelegate delegate: AddEditItemModuleDelegate, from view: UIViewController) {
        let addEditItemModule = AddEditItemWireframe.createAddEditItemModule(for: item, inGroup: group, with: delegate)
        view.present(addEditItemModule, animated: true, completion: nil)
    }
    
    public func dismissAddEditModule(parent: UIViewController) {
        parent.dismiss(animated: true, completion: nil)
    }
    
}
