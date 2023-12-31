//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by Paul Hanson on 12/28/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewControllerTableViewController: UITableViewController {
   
    let realm = try! Realm() //creates a new Realm, normally try! is bad practice
 
    var categories: Results<Category>? //A type from Realm, a container for
  
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()

    }

    //MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //tells the datasource to return the number of rows in a section of the table view
        return categories?.count ?? 1 //if categories is nil, return 1, the '??' is a nil coalescing operator
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //ask the datasource for a cell to insert in a particular location of the table view
        //Note that a Reusable Cell is used because when scrolling a cell out of view,
        //it is deallocated and destroyed and new one created for the cell that comes into view.
        //With dequeue, the actual cell is reused which means that the checked property is maintained.
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        //dequeueReusableCell - Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table.
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category Added Yet"
       
        return cell
        }
    
    //MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//      functionality for selecting selecting a category, perform segue to ToListViewController
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row] //This passed the selecting category to the next view controller
        }

    }
    //MARK: - Data Manipulation Methods
    
    
    func save(category: Category) {
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            print("Error saving category, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories( ) {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Add New Categories
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField() //initialized empty

        //Want to add a popup, UI Alet to add a list item and append it.
        let alert = UIAlertController(title: "Add New Todey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) {(action) in
            //what will happen once the user clicke the Add Item button on our UIAlert
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
