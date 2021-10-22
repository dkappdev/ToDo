//
//  AddEditItemPresenter.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 21.10.2021.
//

import Foundation
import UserNotifications

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
            toggleNotification(for: updatedItem)
            interactor?.updateItem(updatedItem)
        } else {
            let newItem = ToDoItemModel(dueDate: dueDate, dateAdded: Date(), id: UUID(), isCompleted: false, text: text, group: group)
            toggleNotification(for: newItem)
            interactor?.createNewItem(newItem)
        }
    }
    
    private func toggleNotification(for item: ToDoItemModel) {
        // If due date is not specified for the item, remove all pending notifications
        guard let dueDate = item.dueDate else {
            let notificationId = item.id?.uuidString ?? ""
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationId])
            return
        }
        
        // Otherwise create a notification request
        // Since item ID is also used as the notification ID, all previous requests will be automatically removed
        
        let content = UNMutableNotificationContent()
        content.title = item.group?.name ?? ""
        content.body = item.text ?? ""
        content.sound = .default
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let uuidString = item.id?.uuidString ?? ""
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

extension AddEditItemPresenter: AnyAddEditItemInteractorOutput {
    
}
