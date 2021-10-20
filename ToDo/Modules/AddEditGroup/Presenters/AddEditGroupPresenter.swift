//
//  AddEditGroupPresenter.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 19.10.2021.
//

import UIKit

public class AddEditGroupPresenter: AnyAddEditGroupPresenter {
    
    public weak var view: AnyAddEditGroupView?
    public var interactor: AnyAddEditGroupInteractorInput?
    public var wireframe: AnyAddEditGroupWireframe?
    
    public weak var delegate: AddEditGroupModuleDelegate?
    
    private let group: ToDoGroupModel?
    
    public init(group: ToDoGroupModel?) {
        self.group = group
    }
    
    public func viewDidLoad() {
        if let group = group {
            view?.showEditScreen(for: group, withColorOptions: interactor?.retrieveColorOptions() ?? [])
        } else {
            view?.showAddScreen(withColorOptions: interactor?.retrieveColorOptions() ?? [])
        }
    }
    
    public func dismiss() {
        delegate?.dismissAddEditScreen()
    }
    
    public func saveGroup(name: String, color: UIColor) {
        if let group = group {
            let updatedGroup = ToDoGroupModel(id: group.id, color: color, name: name, items: group.items)
            interactor?.updateGroup(updatedGroup)
        } else {
            let newGroup = ToDoGroupModel(id: UUID(), color: color, name: name, items: [])
            interactor?.createNewGroup(newGroup)
        }
    }
}

extension AddEditGroupPresenter: AnyAddEditGroupInteractorOutput {
    
}
