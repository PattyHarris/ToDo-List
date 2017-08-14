//
//  ToDoListTableViewController.swift
//  ToDoList
//
//  Created by Patty Harris on 8/11/17.
//  Copyright © 2017 Patty Harris. All rights reserved.
//

import UIKit
import CoreData

class ToDoListTableViewController: UITableViewController {

    // Switched to using Core Data....
    // var toDos : [ToDo] = []
    var toDos : [ToDoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Not needed since we're using Core Data
        // self.toDos = self.createToDos()
        
        // Using Core Data
        getToDos()

    }
    
    // We need to handle this override to ensure that when we come
    // back to this view, the data is reloaded into the tableView.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getToDos()
    }

    // Initially set with dummy data to test the tableView
    // No longer needed since we are now using Core Data
    func createToDos() -> [ToDo] {
        
        let eggs: ToDo = ToDo()
        eggs.name = "Buy eggs"
        eggs.isImportant = true
        
        let walkTheDog : ToDo = ToDo()
        walkTheDog.name = "Walk the dog"
        walkTheDog.isImportant = false
        
        let eatCheese: ToDo = ToDo()
        eatCheese.name = "Eat cheese"
        eatCheese.isImportant = false
        
        return [eggs, walkTheDog, eatCheese]
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)

        let todo = toDos[indexPath.row]
        
        // Since we're using Core Data, todo.name is now an
        // optional.
        if var name = todo.name {
            
            if (todo.isImportant) {
                name = "❗️" + name
            }

            cell.textLabel?.text = name
        }
        

        return cell
    }
    
    // Get the ToDos from CoreData
    func getToDos() {
        
        if let context  =
            ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext) {
            
            do {
                let coreDataToDos = try context.fetch(ToDoItem.fetchRequest()) as? [ToDoItem]
                
                if let coreDataToDos = coreDataToDos {
                    // We can just set our ToDoItem array to the one given
                    // to us by Core Data - note that toDos is now [ToDoItem]
                    self.toDos = coreDataToDos
                }
                
                tableView.reloadData()
            }
            catch {
                showAlert(message: "Could not retrieve the ToDo items from the database!  Please try again.")
                return
            }
        }
    }
    
    // In the tutorial, the code was handled by the add ToDo VC,
    // which isn't the best.  I added the function handler instead.
    func addNewToDo(toDo: ToDo) -> Bool {
        
        /* Commented out to use Core Data instead
        if let toDo = toDo as ToDo? {
            toDos.append(toDo)
            tableView.reloadData()
        }*/
        
        var success : Bool = true
        
        // Get the managed object context
        if let context  =
            ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext) {
        
            let toDoItem = ToDoItem(entity: ToDoItem.entity(), insertInto: context)
            
            toDoItem.name = toDo.name
            toDoItem.isImportant = toDo.isImportant
            
            // This can also be handled this way:
            // try? context.save
            // But then there's no handling the failure case...
            // To get the data to "reload" we need to handle
            // viewWillAppear.
            do {
                try context.save()
            }
            catch {
                self.showAlert(message: "Data could not be saved!  Please try again.")
                success = false
            }
        }
        return success
    }
    
    // Added the function instead of code directly in other view
    func completeToDo(toDo toRemove: ToDoItem) {
        
        // Using Core Data, all we need to do is remove the item
        // from Core Data.
        if let context  =
            ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext) {
            
            context.delete(toRemove)
            
            // Update the tableView
            getToDos()
        }
            
    }

    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Navigation

    // We will use this prepare to give the add ToDo VC a reference to this
    // View Controller.  Using if let to make sure the destination IS a add VC.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let addVC = segue.destination as? AddToDoViewController {
            addVC.toDoListTableViewVC = self
        }
        else if let completeVC = segue.destination as? CompleteToDoViewController {
            completeVC.toDoListTableViewVC = self
            if let toDo = sender as? ToDoItem {
                completeVC.selectedToDo = toDo
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let toDo = toDos[indexPath.row]
        performSegue(withIdentifier: "completeToDoSegue", sender: toDo)
    }

}
