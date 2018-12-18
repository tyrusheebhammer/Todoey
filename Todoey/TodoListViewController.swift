//
//  ViewController.swift
//  Todoey
//
//  Created by Tyrus Sonneborn on 12/17/18.
//  Copyright © 2018 Tyrus Sonneborn. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController{
    
    let itemArray = ["Play Football", "Code with death", "Pass 498", "dog", "CAT", "fart"]
    
    func getColor(forItemAt indexPath: Int) -> UIColor{
        let val = 1*(1-CGFloat(indexPath)*0.15)
        let red = val >= 0 ? val : 0
        return UIColor(displayP3Red: red, green: 0, blue: 0, alpha: 0.85)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // Create tableview datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        cell.backgroundColor = getColor(forItemAt: indexPath.row)
        return cell
    }
    
    // Create TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}


