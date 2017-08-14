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
    var selectedToDo: ToDo = ToDo()

    @IBOutlet weak var completeToDoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var name = selectedToDo.name
        if (selectedToDo.isImportant) {
            name = "❗️" + name
        }

        completeToDoLabel.text = name
    }

    @IBAction func completeButtonDidTap(_ sender: Any) {
        toDoListTableViewVC.completeToDo(toDo: selectedToDo)
        
        navigationController?.popViewController(animated: true)
    }
    
}
