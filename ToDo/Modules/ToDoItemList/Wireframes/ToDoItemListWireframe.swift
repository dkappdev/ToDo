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
    
    public func presentAddItemScreen() {
        assertionFailure("presentAddItemScreen() has not yet been implemented")
    }
    
    public func presentEditItemScreen(for item: ToDoItemModel) {
        assertionFailure("presentEditItemScreen(for:) has not yet been implemented")
    }
    
}
