//
//  ToDoItemListView.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 18.10.2021.
//

import UIKit

public class ToDoItemListView: UIViewController {
    private static let toDoItemCellReuseIdentifier = "ToDoItemCell"
    private var tableView: UITableView!
    
    public var presenter: AnyToDoItemListPresenter?
    private var itemList: [ToDoItemModel] = []
    
    // MARK: - View life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up table view
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        view = tableView
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.toDoItemCellReuseIdentifier)
        
        // Setting up navigation item
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        
        presenter?.viewDidLoad()
    }
    
    // MARK: - Responding to user actions
    
    @objc private func addItem() {
        presenter?.addItem()
    }
    
    private func deleteItem(at indexPath: IndexPath) {
        let item = itemList.remove(at: indexPath.row)
        presenter?.deleteItem(item)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - Module methods

extension ToDoItemListView: AnyToDoItemListView {
    public func showToDoItemsForGroup(_ group: ToDoGroupModel) {
        navigationController?.navigationBar.tintColor = group.color
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: group.color as Any]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: group.color as Any]
        navigationItem.title = group.name
        
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
    
}
