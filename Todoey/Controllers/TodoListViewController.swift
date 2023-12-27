//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData


class TodoListViewController: UITableViewController {
    //by subclassing to UITableViewController, we get a lot of free functionality, for example, no need to create IBOutlets.
    
//    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        
//        print(dataFilePath!)

        loadItems()
        
    }

//MARK - Tableview Datasource Methods
    //Note that the implementation in this app as compared to the FlashChat app is simpler because of the subclassing of ToDoListViewController to UITableViewController
    //as opposed to UIViewController. The IBOutlets are handled behind the scenes.
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //tells the datasource to return the number of rows in a section of the table view
        return itemArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //ask the datasource for a cell to insert in a particular location of the table view
        //Note the lesson reference for code sense, the list of symbols for the autocompleting code to distinguish category of code to be inserted
        //In this case L or V for local or global variable for tableView are OK.
        //Note that a Reusable Cell is used because when scrolling a cell out of view, it is deallocated and destroyed and new one created for the cell that comes into view. With dequeue, the actual cell is reused which means that the checked property is maintained.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        //dequeueReusableCell - Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table.
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none

        
        return cell
        }
        
   //MARK - TableView Delegate Methods
    //First, the one that gets fired upon any click in a cell
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//      functionality for selecting a row
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //toggle the value done
        
        saveItems()
        

        //want to delect quickly so that the UI only flashed gray briefly
        tableView.deselectRow(at: indexPath, animated: true)
    }
       
//MARK - Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField() //initialized empty

        //Want to add a popup, UI Alet to add a list item and append it.
        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) {(action) in
            //what will happen once the user clicke the Add Item button on our UIAlert
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            self.saveItems()
            
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
    }
    func loadItems() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching context, \(error)")
        }
    }
}

