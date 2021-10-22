//
//  AddEditItemView.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 21.10.2021.
//

import UIKit

public class AddEditItemView: UIViewController {
    // Table view properties
    private var tableView: UITableView!
    private static let textFieldCellReuseIdentifier = "TextFieldCell"
    private static let datePickerCellReuseIdentifier = "DatePickerCell"
    
    // Static cells
    private var textField: UITextField!
    private var datePicker: UIDatePicker!
    private var textFieldCell: UITableViewCell!
    private var dueDateSwitch: UISwitch!
    private var datePickerCell: UITableViewCell!
    
    // VIPER properties
    public var presenter: AnyAddEditItemPresenter?
    
    /// The item user is editing. If a new item is being added, this property is equal to `nil`
    private var item: ToDoItemModel?
    
    // MARK: - View life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up navigation bar
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBarButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBarButtonTapped))
    }
    
    // MARK: - Cell setup
    
    // MARK: - Responding to user actions
    
    @objc private func cancelBarButtonTapped() {
        presenter?.dismiss()
    }
    
    @objc private func saveBarButtonTapped() {
        if dueDateSwitch.isOn {
            presenter?.saveItem(text: textField.text ?? "", dueDate: datePicker.date)
        } else {
            presenter?.saveItem(text: textField.text ?? "", dueDate: nil)
        }
        presenter?.dismiss()
    }
    
}

// MARK: - Module methods

extension AddEditItemView: AnyAddEditItemView {
    
    public func showAddScreen() {
        
    }
    
    public func showEditScreen(for item: ToDoItemModel) {
        
    }
    
    
}

// MARK: - Table view data source

// MARK: - Table view delegate
