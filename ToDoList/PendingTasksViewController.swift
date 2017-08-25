//
//  PendingTasksViewController.swift
//  ToDoList
//
//  Created by SOMNATH CHATTERJEE on 25/08/17.
//  Copyright © 2017 SOMNATH CHATTERJEE. All rights reserved.
//

import UIKit
import RealmSwift

class PendingTasksViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    // MARK: Variables and Outlets

    var todoListPending : Results<TodoItem>!
    @IBOutlet weak var tableViewTasks: UITableView!
    
    // MARK: View Controller Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        readTasksAndUpdateUI()
    }
    
    // MARK: UI Setup

    func readTasksAndUpdateUI(){
        
        todoListPending = realm.objects(TodoItem.self).filter("taskCompletionStatus = false")
        self.tableViewTasks.reloadData()
    }
    
    func setupUI() {
        tableViewTasks.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    
    // MARK: Add Tasks

    @IBAction func btnAddTaskDidTap(_ sender: Any) {
        let alertController = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Add", style: .default, handler: {
            alert -> Void in
            
            let taskName = alertController.textFields?.first?.text
            let todoItem = TodoItem()
            todoItem.taskName = taskName!
            todoItem.taskCompletionStatus = false
            
            try! realm.write({
                realm.add(todoItem)
            })
            self.readTasksAndUpdateUI()
            
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Task Name"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: UITableView
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let listsTasks = todoListPending{
            return listsTasks.count
        }
        return 0
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = todoListPending[indexPath.row]
        cell.textLabel?.text = item.taskName
        if (item.taskCompletionStatus) {
            cell.detailTextLabel?.text = "Done"
        }else{
            cell.detailTextLabel?.text = "Pending"
            
        }
        return cell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let item = self.todoListPending[indexPath.row]
        try! realm.write({
            if (item.taskCompletionStatus){
                item.taskCompletionStatus = false
            }else{
                item.taskCompletionStatus = true
            }
        })
        self.readTasksAndUpdateUI()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (deleteAction, indexPath) -> Void in
            let listToBeDeleted = self.todoListPending[indexPath.row]
            try! realm.write{
                realm.delete(listToBeDeleted)
                self.readTasksAndUpdateUI()
            }
        }
        return [deleteAction]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
