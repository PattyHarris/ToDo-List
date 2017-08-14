//
//  AddToDoViewController.swift
//  ToDoList
//
//  Created by Patty Harris on 8/12/17.
//  Copyright © 2017 Patty Harris. All rights reserved.
//

import UIKit

class AddToDoViewController: UIViewController {

    // This will be set in the prepare segue in the tableView VC.
    var toDoListTableViewVC : ToDoListTableViewController = ToDoListTableViewController()
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var importantSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func addButtonDidTap(_ sender: Any) {
        
        let toDo = ToDo()
        
        // It's bad practice to force unwrap an optional - e.g.
        // titleTextField.text!
        // This may be nil - as part of the tutorial on optionals,
        // this was corrected using if let - which basically
        // says that if the text field is not nil, proceed.
        // I added the alert.

        if let name = titleTextField.text {
            
            if name.isEmpty {
                // Show an alert
                let message = "Please enter a title to complete the ToDo."
                showAlert(message: message)
                
                return
            }
            else {
                toDo.name = name
            }

        }
        
        toDo.isImportant = importantSwitch.isOn
        
        toDoListTableViewVC.addNewToDo(toDo: toDo)
        
        // Return to the prior view controller.
        navigationController?.popViewController(animated: true)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "ToDo Title Missing", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}
