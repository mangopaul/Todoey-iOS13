//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    //by subclassing to UITableViewController, we get a lot of free functionality, for example, no need to create IBOutlets.
    
    let itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
        let item = itemArray[indexPath.row]
        //Note the lesson reference for code sense, the list of symbols for the autocompleting code to distinguish category of code to be inserted
        //In this case L or V for local or global variable for tableView are OK.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        //dequeueReusableCell - Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table.
        cell.textLabel?.text = item
        
        return cell
        }
        
   //MARK - TableView Delegate Methods
    //First, the one that gets fired upon any click in a cell
    
      
       

}

