//
//  CompleteToDoViewController.swift
//  ToDoList
//
//  Created by Patty Harris on 8/13/17.
//  Copyright © 2017 Patty Harris. All rights reserved.
//

import UIKit

class CompleteToDoViewController: UIViewController {

    // This will be set in the prepare segue in the tableView VC.
    var toDoListTableViewVC : ToDoListTableViewController = ToDoListTableViewController()
    var selectedToDo: ToDoItem?

    @IBOutlet weak var completeToDoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // You can also set this (without the ! code as
        // completeToDoLabel.text = selectedToDo?.name
        // Ths says if the selectedToDo isn't nil, use it,
        // otherwise, set the name as nil...
        
        if let selectedToDo = self.selectedToDo {
            
            if var name = selectedToDo.name {
                if (selectedToDo.isImportant) {
                    name = "❗️" + name
                }

                completeToDoLabel.text = name
            }
        }
    }

    @IBAction func completeButtonDidTap(_ sender: Any) {
        
        if let completedToDo = selectedToDo {
            toDoListTableViewVC.completeToDo(toDo: completedToDo)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}
