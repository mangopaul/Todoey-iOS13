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
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadCategories()

    }

    //MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //tells the datasource to return the number of rows in a section of the table view
        return categories.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //ask the datasource for a cell to insert in a particular location of the table view
        //Note the lesson reference for code sense, the list of symbols for the autocompleting code to distinguish category of code to be inserted
        //In this case L or V for local or global variable for tableView are OK.
        //Note that a Reusable Cell is used because when scrolling a cell out of view, it is deallocated and destroyed and new one created for the cell that comes into view. With dequeue, the actual cell is reused which means that the checked property is maintained.
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        //dequeueReusableCell - Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table.
        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category.name
        
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
            destinationVC.selectedCategory = categories[indexPath.row]
        }

    }
    //MARK: - Data Manipulation Methods
    
    
    func save(category: Category) {
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories( ) {
//        In the function declaration above, the "= Item.fetchRequest()" is a default value for request if none is provided
//        do {
//            categories = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context, \(error)")
//        }
//        
//        tableView.reloadData()
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
            self.categories.append(newCategory)
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
