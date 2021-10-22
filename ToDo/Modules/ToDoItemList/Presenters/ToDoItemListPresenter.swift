//
//  ToDoItemListPresenter.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 18.10.2021.
//

import Foundation
import UIKit

public class ToDoItemListPresenter: AnyToDoItemListPresenter {
    public weak var view: AnyToDoItemListView?
    public var interactor: AnyToDoItemListInteractorInput?
    public var wireframe: AnyToDoItemListWireframe?
    
    private let group: ToDoGroupModel
    
    public init(group: ToDoGroupModel) {
        self.group = group
    }
    
    public func viewDidLoad() {
        interactor?.requestUpdatedToDoGroup(group)
    }
    
    public func addItem() {
        wireframe?.presentAddItemModule(forItemInGroup: group, withDelegate: self, from: view as? UIViewController ?? UIViewController())
    }
    
    public func editItem(_ item: ToDoItemModel) {
        wireframe?.presentEditItemModule(for: item, in: group, withDelegate: self, from: view as? UIViewController ?? UIViewController())
    }
    
    public func deleteItem(_ item: ToDoItemModel) {
        interactor?.removeToDoItem(item)
    }
    
    
}

extension ToDoItemListPresenter: AnyToDoItemListInteractorOutput {
    public func didReceiveNewToDoGroup(_ group: ToDoGroupModel) {
        view?.showToDoItemsForGroup(group)
    }
}

extension ToDoItemListPresenter: AddEditItemModuleDelegate {
    public func dismissAddEditScreen() {
        interactor?.requestUpdatedToDoGroup(group)
        wireframe?.dismissAddEditModule(parent: view as? UIViewController ?? UIViewController())
    }
}
