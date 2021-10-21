//
//  AddEditItemView.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 21.10.2021.
//

import UIKit

public class AddEditItemView: UIViewController {
    // VIPER properties
    public var presenter: AnyAddEditItemPresenter?
    
}

extension AddEditItemView: AnyAddEditItemView {
    
    public func showAddScreen() {
        
    }
    
    public func showEditScreen(for item: ToDoItemModel) {
        
    }
    
    
}
