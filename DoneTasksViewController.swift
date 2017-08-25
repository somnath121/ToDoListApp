//
//  DoneTasksViewController.swift
//  ToDoList
//
//  Created by SOMNATH CHATTERJEE on 25/08/17.
//  Copyright © 2017 SOMNATH CHATTERJEE. All rights reserved.
//

import UIKit
import RealmSwift

class DoneTasksViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate {
    
    // MARK: Variables and Outlets

    var todoListDone : Results<TodoItem>!
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
        
        todoListDone = realm.objects(TodoItem.self).filter("taskCompletionStatus = true")
        self.tableViewTasks.reloadData()
    }
    
    func setupUI() {
        tableViewTasks.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    
        // MARK: UITableView
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let listsTasks = todoListDone{
            return listsTasks.count
        }
        return 0
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = todoListDone[indexPath.row]
        cell.textLabel?.text = item.taskName
        return cell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let item = self.todoListDone[indexPath.row]
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
            let listToBeDeleted = self.todoListDone[indexPath.row]
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

