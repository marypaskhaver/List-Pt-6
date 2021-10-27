//
//  ViewController.swift
//  List
//
//  Created by Mary Paskhaver on 10/21/21.
//

import UIKit
import CoreData

class ViewController: UITableViewController {

    // Create toDos ToDo array as a property of ViewController to hold default to-do data
    var toDos: [ToDoEntity] = []
    
    // Whenever ViewController's add button is pressed, this function is called
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Create an alert that prompts the user to add a new to-do item
        let alert = UIAlertController(title: "Add a To-Do", message: "", preferredStyle: .alert)
        
        // Add a text field to that alert with a placeholder
        alert.addTextField { (toDoTextField) in
            toDoTextField.placeholder = "Enter a to-do."
        }
        
        // Create an alert action that puts a Done button on the alert and, when Done is pressed, gets the new to-do's text from the alert's text field, creates a ToDo object with it, adds that object to self.toDos, and refreshes ViewController's tableView so the new to-do shows up
        let alertAction = UIAlertAction(title: "Done", style: .default, handler: { (action) in
            // Get user input with white space and new lines removed
            let newToDoDescription = alert.textFields![0].text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Only create a ToDoEntity / save to CoreData if user input is not an empty String
            if (!newToDoDescription.isEmpty) {
                let newToDo = ToDo(newToDoDescription)
                
                // Get context (area we're saving to) from AppDelegate
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext

                // Create new ToDoEntity
                let newToDoEntityToSave = ToDoEntity(context: context)
                newToDoEntityToSave.desc = newToDo.description
                newToDoEntityToSave.isComplete = newToDo.isComplete
                
                do {
                    try context.save()
                } catch {
                    // If saving fails for some reason, print the error
                    let error = error as NSError
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
                
                self.toDos.append(newToDoEntityToSave)
                self.tableView.reloadData()
            }
        })

        // Add the action to the alert
        alert.addAction(alertAction)

        // Present the alert with an animation when the add button is pressed
        self.present(alert, animated: true)
    }
    
    // Code that runs when ViewController view loads up
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        // Get context that data was saved to previously
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // Create fetch request to retrieve ToDoEntity objects from CoreData
        let toDoFetchRequest = ToDoEntity.fetchRequest()
        
        // If you can, fetch existing ToDoEntity entities and fill toDos with them
        do {
            let savedToDos = try context.fetch(toDoFetchRequest)
            toDos = savedToDos
        } catch {
            // If fetching ToDoEntity entities fails for some reason, print the error
            let error = error as NSError
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
        
    }
    
    // Returns the number of rows in each section of ViewController's tableView. Since there is only 1 section, the number of rows in it is equal to the number of elements in ViewController's toDos property.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.toDos.count
    }
    
    // Handles filling cells with text from ViewController's toDos
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Gets the ToDo object represented by this cell at this given indexPath
        let toDo = self.toDos[indexPath.row]
        
        // Gets a UITableViewCell object with identifier "toDoCell" in ViewController's tableView at the given indexPath
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        
        // Get the contentConfiguration of the cell and change its text to toDo's description property
        var content = cell.defaultContentConfiguration()
        content.text = toDo.desc
        
        // Reset cell's contentConfiguration to the new contentConfiguration called content whose text we changed
        cell.contentConfiguration = content
        
        // Give cell a checkmark or none if the ToDo object represented by this cell is complete or not
        if (toDo.isComplete == true) {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
                
        // Return the cell
        return cell
    }
    
    // Toggle's a ToDo object's isComplete property when the cell representing that ToDo is tapped / selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the cell in ViewController's tableView
        self.tableView.deselectRow(at: indexPath, animated: false)

        // Get the ToDo object corresponding to this cell. Set its isComplete property to the opposite of what it currently is.
        let tappedToDo = self.toDos[indexPath.row]
        tappedToDo.isComplete = !tappedToDo.isComplete
        
        // Reload tableView's data at the tapped indexPath
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }

}
