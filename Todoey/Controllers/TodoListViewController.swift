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
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{ //do the steps in the block below when this variable is set
                loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }

//MARK: - Tableview Datasource Methods
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
        
   //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//      functionality for selecting a row
        //sample code for deleting a row instead of toggling the check mark
        //Note that the order matters in the code below. Need to delete the item in the context first
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
      
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //toggle the value done
        
        saveItems()
        

        //want to delect quickly so that the UI only flashed gray briefly
        tableView.deselectRow(at: indexPath, animated: true)
    }
       
//MARK: - Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField() //initialized empty

        //Want to add a popup, UI Alet to add a list item and append it.
        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) {(action) in
            //what will happen once the user clicke the Add Item button on our UIAlert
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
    // In the function declaration above, the "= Item.fetchRequest()" is a default value for request if none is provided
    // With the categories now in the data model, need to query for the items belonging to the selected category
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate {
            //if a predicate was passed as an argument...
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }

        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    
}
//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let  predicate = NSPredicate(format: "title CONTAINS [cd] %@", searchBar.text!)
        //see the NSPredecate Cheat Sheet for Realm: https://academy.realm.io/posts/nspredicate-cheatsheet/
        //string comparisons are be default case and diacritic sensitive unless you include [cd] for case and diacritic insensitive
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)

        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search text: \(searchText)")
            
        
//        The next code changes the focus from the searchBar back to the items list if the searchBar text field is blank,
        if(searchBar.text?.count == 0) {
            loadItems()
            DispatchQueue.main.async{
                searchBar.resignFirstResponder()
            }
        } else {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            let  predicate = NSPredicate(format: "title CONTAINS [cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            loadItems(with: request, predicate: predicate)
        }
    }
}

