//
//  ToDoItemListView.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 18.10.2021.
//

import UIKit

public class ToDoItemListView: UIViewController {
    // Table view properties
    private static let toDoItemCellReuseIdentifier = "ToDoItemCell"
    private var tableView: UITableView!
    
    // VIPER properties
    public var presenter: AnyToDoItemListPresenter?
    private var itemList: [ToDoItemModel] = []
    
    /// Cached group color
    private var groupColor: UIColor?
    
    // MARK: - View life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up table view
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        view = tableView
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.toDoItemCellReuseIdentifier)
        
        // Setting up navigation item
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        
        presenter?.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarTextColor(groupColor)
    }
    
    // MARK: - Responding to user actions
    
    /// Creates a new to-do item
    @objc private func addItem() {
        presenter?.addItem()
    }
    
    /// Delete to-do item at specified location
    /// - Parameter indexPath: item location
    private func deleteItem(at indexPath: IndexPath) {
        let item = itemList.remove(at: indexPath.row)
        presenter?.deleteItem(item)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Utility functions
    
    /// Sets navigation bar color
    /// - Parameter color: new navigation bar color. If `color` is `nil`, no changes are made to the status bar
    private func setNavigationBarTextColor(_ color: UIColor?) {
        guard let color = color else { return }
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: color as Any]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: color as Any]
    }
}

// MARK: - Module methods

extension ToDoItemListView: AnyToDoItemListView {
    /// Called when updated group model has been received. This method displays item list from the new group model
    /// - Parameter group: new group model
    public func showToDoItemsForGroup(_ group: ToDoGroupModel) {
        // Remembering group color
        groupColor = group.color
        
        // Setting up navigation bar
        setNavigationBarTextColor(groupColor)
        navigationItem.title = group.name
        
        // Displaying items
        itemList = group.items ?? []
        tableView.reloadData()
    }
}

// MARK: - Table view data source

extension ToDoItemListView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.toDoItemCellReuseIdentifier, for: indexPath)
        let item = itemList[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = item.text
        cell.contentConfiguration = content
        
        return cell
    }
}

// MARK: - Table view delegate

extension ToDoItemListView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { action, view, completionHandler in
            self.deleteItem(at: indexPath)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.accessibilityLabel = NSLocalizedString("delete_action_accessibility_label", comment: "")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let itemModel = itemList[indexPath.row]
        presenter?.editItem(itemModel)
    }
}
