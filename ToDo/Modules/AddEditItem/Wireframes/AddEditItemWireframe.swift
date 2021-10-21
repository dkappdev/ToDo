//
//  AddEditItemWireframe.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 21.10.2021.
//

import UIKit

public class AddEditItemWireframe: AnyAddEditItemWireframe {
    public static func createAddEditItemModule(for item: ToDoItemModel?, inGroup group: ToDoGroupModel, with delegate: AddEditItemModuleDelegate) -> UIViewController {
        let view: AnyAddEditItemView & UIViewController = AddEditItemView()
        let presenter: AnyAddEditItemPresenter & AnyAddEditItemInteractorOutput = AddEditItemPresenter(group: group, item: item)
        let interactor: AnyAddEditItemInteractorInput = AddEditItemInteractor()
        let localDataManager: AnyAddEditItemLocalDataManager = AddEditItemCoreDataManager()
        let wireframe: AnyAddEditItemWireframe = AddEditItemWireframe()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.wireframe = wireframe
        presenter.interactor = interactor
        presenter.delegate = delegate
        
        interactor.presenter = presenter
        interactor.localDataManager = localDataManager
        
        return UINavigationController(rootViewController: view)
    }
    
    public func dismissAddEditScreen(using delegate: AddEditItemModuleDelegate?) {
        delegate?.dismissAddEditScreen()
    }
    
    
}
