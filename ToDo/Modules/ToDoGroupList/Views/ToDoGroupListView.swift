//
//  ToDoGroupListView.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 17.10.2021.
//

import UIKit

public class ToDoGroupListView: UIViewController {
    // Table view properties
    private static let toDoGroupCellReuseIdentifier = "ToDoGroupCell"
    private var tableView: UITableView!
    
    public var presenter: AnyToDoGroupListPresenter?
    private var groupList: [ToDoGroupModel] = []
    
    // MARK: - View life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up table view
        tableView = UITableView(frame: view.frame, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        view = tableView
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.toDoGroupCellReuseIdentifier)
        
        // Setting up navigation item
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = NSLocalizedString("group_list_title", comment: "")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGroup))
        
        presenter?.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarColor(UIColor.label)
        
        tableView.indexPathsForVisibleRows?.forEach{ indexPath in
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // MARK: - Responding to user actions
    
    @objc private func addGroup() {
        presenter?.addGroup()
    }
    
    private func deleteGroup(at indexPath: IndexPath) {
        let group = groupList.remove(at: indexPath.row)
        presenter?.deleteGroup(group)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Utility functions

    private func setNavigationBarColor(_ color: UIColor?) {
        guard let color = color else { return }
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: color]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: color]
    }
}

// MARK: - Module methods

extension ToDoGroupListView: AnyToDoGroupListView {
    
    public func showToDoGroups(_ groups: [ToDoGroupModel]) {
        groupList = groups
        tableView.reloadData()
    }
    
}

// MARK: - Table view data source

extension ToDoGroupListView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groupList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.toDoGroupCellReuseIdentifier, for: indexPath)
        let group = groupList[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = group.name
        var image = UIImage(systemName: "list.bullet.circle.fill")
        if let color = group.color {
            image = image?.withTintColor(color, renderingMode: .alwaysOriginal)
        }
        content.image = image
        cell.contentConfiguration = content
        
        return cell
    }
}

// MARK: - Table view delegate

extension ToDoGroupListView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { action, view, completionHandler in
            self.deleteGroup(at: indexPath)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.accessibilityLabel = NSLocalizedString("delete_action_accessibility_label", comment: "")
        
        let editAction = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            let group = self.groupList[indexPath.row]
            self.presenter?.editGroup(group)
            completionHandler(true)
        }
        editAction.image = UIImage(systemName: "slider.horizontal.3")
        editAction.accessibilityLabel = NSLocalizedString("edit_action_accessibility_label", comment: "")
        editAction.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = groupList[indexPath.row]
        presenter?.showToDoItemList(for: group)
    }
}


