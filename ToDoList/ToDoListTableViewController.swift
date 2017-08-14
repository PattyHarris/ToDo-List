//
//  ToDoListTableViewController.swift
//  ToDoList
//
//  Created by Patty Harris on 8/11/17.
//  Copyright © 2017 Patty Harris. All rights reserved.
//

import UIKit

class ToDoListTableViewController: UITableViewController {

    var toDos : [ToDo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.toDos = self.createToDos()

    }

    // Initially set with dummy data to test the tableView
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
        
        var name = todo.name
        if (todo.isImportant) {
            name = "❗️" + name
        }
        cell.textLabel?.text = name

        return cell
    }
    
    // In the tutorial, the code was handled by the add ToDo VC,
    // which isn't the best.  I added the function handler instead.
    func addNewToDo(toDo: ToDo) {
        if let toDo = toDo as ToDo? {
            toDos.append(toDo)
            tableView.reloadData()
        }
    }
    
    // Added the function instead of code directly in other view
    func completeToDo(toDo toRemove: ToDo) {
        let count = toDos.count
        
        for count in 0...(count - 1) {
            
            let toDo = toDos[count]

            if toDo.name == toRemove.name && toDo.isImportant == toRemove.isImportant {
                toDos.remove(at: count)
                tableView.reloadData()
                return
            }
        }
        
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
            if let toDo = sender as? ToDo {
                completeVC.selectedToDo = toDo
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let toDo = toDos[indexPath.row]
        performSegue(withIdentifier: "completeToDoSegue", sender: toDo)
    }

}
