//
//  AddEditItemPresenter.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 21.10.2021.
//

import Foundation

public class AddEditItemPresenter: AnyAddEditItemPresenter {
    
    public weak var view: AnyAddEditItemView?
    public var interactor: AnyAddEditItemInteractorInput?
    public var wireframe: AnyAddEditItemWireframe?
    
    public weak var delegate: AddEditItemModuleDelegate?
    
    private let group: ToDoGroupModel
    private let item: ToDoItemModel?
    
    public init(group: ToDoGroupModel, item: ToDoItemModel?) {
        self.group = group
        self.item = item
    }
    
    public func viewDidLoad() {
        if let item = item {
            view?.showEditScreen(for: item)
        } else {
            view?.showAddScreen()
        }
    }
    
    public func dismiss() {
        delegate?.dismissAddEditScreen()
    }
    
    public func saveItem(text: String, dueDate: Date?) {
        if let item = item {
            let updatedItem = ToDoItemModel(dueDate: dueDate, dateAdded: item.dateAdded, id: item.id, isCompleted: item.isCompleted, text: text, group: item.group)
            interactor?.updateItem(updatedItem)
        } else {
            let newItem = ToDoItemModel(dueDate: dueDate, dateAdded: Date(), id: UUID(), isCompleted: false, text: text, group: group)
            interactor?.createNewItem(newItem)
        }
    }
}

extension AddEditItemPresenter: AnyAddEditItemInteractorOutput {
    
}
