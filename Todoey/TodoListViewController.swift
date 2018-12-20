//
//  ViewController.swift
//  Todoey
//
//  Created by Tyrus Sonneborn on 12/17/18.
//  Copyright © 2018 Tyrus Sonneborn. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController{
    let todoArrayKey = "todoItemArray"
    var itemArray = [String]()
    let defaults = UserDefaults.standard
    func getColor(forItemAt indexPath: Int) -> UIColor{
//        let val = 1*(1-CGFloat(indexPath)*0.15)
//        let red = val >= 0 ? val : 0
//        return UIColor(displayP3Red: red, green: 0, blue: 0, alpha: 0.85)
        return UIColor(displayP3Red: 0.9, green: 0.9, blue: 1, alpha: 1)
    }
    
    override func viewDidLoad() {
        if let items = defaults.array(forKey: todoArrayKey) as? [String]{
            self.itemArray = items
        }
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK: Create tableview datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        cell.backgroundColor = getColor(forItemAt: indexPath.row)
        return cell
    }
    
    //MARK: Create TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: Add new items
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        var textField = UITextField()
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when user clicks the add item button on the UI alert
            self.itemArray.append(textField.text!)
            self.defaults.set(self.itemArray, forKey: self.todoArrayKey)
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
}


