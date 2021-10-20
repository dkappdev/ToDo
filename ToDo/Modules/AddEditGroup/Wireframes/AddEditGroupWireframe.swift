//
//  AddEditGroupWireframe.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 19.10.2021.
//

import UIKit

public class AddEditGroupWireframe: AnyAddEditGroupWireframe {
    public static func createAddEditGroupModule(for group: ToDoGroupModel?, with delegate: AddEditGroupModuleDelegate) -> UIViewController {
        let view: AnyAddEditGroupView & UIViewController = AddEditGroupView()
        let presenter: AnyAddEditGroupPresenter & AnyAddEditGroupInteractorOutput = AddEditGroupPresenter(group: group)
        let interactor: AnyAddEditGroupInteractorInput = AddEditGroupInteractor()
        let localDataManager: AnyAddEditGroupLocalDataManager = AddEditGroupCoreDataManager()
        let wireframe: AnyAddEditGroupWireframe = AddEditGroupWireframe()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.wireframe = wireframe
        presenter.interactor = interactor
        presenter.delegate = delegate
        
        interactor.presenter = presenter
        interactor.localDataManager = localDataManager
        
        return UINavigationController(rootViewController: view)
    }
    
    public func dismissAddEditScreen(using delegate: AddEditGroupModuleDelegate?) {
        delegate?.dismissAddEditScreen()
    }
}
