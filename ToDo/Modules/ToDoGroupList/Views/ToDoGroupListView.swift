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
    
    // VIPER properties
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
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.toDoGroupCellReuseIdentifier)
        
        // Setting up navigation item
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = NSLocalizedString("group_list_title", comment: "")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGroup))
        
        presenter?.viewDidLoad()
        
        requestNotificationAccess()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarTextColor(UIColor.label)
        
        tableView.indexPathsForVisibleRows?.forEach{ indexPath in
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        presenter?.requestNewGroupList()
    }
    
    // MARK: - Responding to user actions
    
    /// Adds a new to-do group
    @objc private func addGroup() {
        presenter?.addGroup()
    }
    
    /// Delete to-do group at specified location
    /// - Parameter indexPath: group location
    private func deleteGroup(at indexPath: IndexPath) {
        let group = groupList.remove(at: indexPath.row)
        presenter?.deleteGroup(group)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Utility functions
    
    /// Sets up navigation bar
    /// - Parameter color: new navigation bar color
    private func setNavigationBarTextColor(_ color: UIColor?) {
        guard let color = color else { return }
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: color]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: color]
    }
    
    private func requestNotificationAccess() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { setting in
            if setting.authorizationStatus == .notDetermined {
                notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
                    
                }
            }
        }
    }
}

// MARK: - Module methods

extension ToDoGroupListView: AnyToDoGroupListView {
    
    /// Called when group models have been successfully received. This method display to-do group list
    /// - Parameter groups: new to-do group
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
        
        cell.accessoryType = .disclosureIndicator
        
        var content = cell.defaultContentConfiguration()
        content.text = group.name
        
        let imageConfig = UIImage.SymbolConfiguration(paletteColors: [.white, group.color ?? .systemBlue])
        let image = UIImage(systemName: "list.bullet.circle.fill")?.applyingSymbolConfiguration(imageConfig)
        content.image = image
        
        content.prefersSideBySideTextAndSecondaryText = true
        content.secondaryText = "\(group.items?.count ?? 0)"
        
        content.secondaryTextProperties.font = .preferredFont(forTextStyle: .body)
        content.secondaryTextProperties.color = .secondaryLabel
        
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
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = groupList[indexPath.row]
        presenter?.showToDoItemList(for: group)
    }
}


