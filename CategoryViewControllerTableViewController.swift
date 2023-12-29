//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by Paul Hanson on 12/28/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewControllerTableViewController: UITableViewController {
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
    //MARK: - Data Manipulation Methods
    
    
    func saveCategories() {
        let encoder = PropertyListEncoder()
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest() ) {
//        In the function declaration above, the "= Item.fetchRequest()" is a default value for request if none is provided
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK: - Add New Categories
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField() //initialized empty

        //Want to add a popup, UI Alet to add a list item and append it.
        let alert = UIAlertController(title: "Add New Todey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) {(action) in
            //what will happen once the user clicke the Add Item button on our UIAlert
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            self.saveCategories()
            
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

    
    //MARK: - TableView Delegate Methods
    
    

    
}
