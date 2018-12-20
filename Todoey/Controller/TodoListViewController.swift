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
    var itemArray = [TodoItem]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TodoItems.plist")
    
    func getColor(forItemAt indexPath: Int) -> UIColor{
//        let val = 1*(1-CGFloat(indexPath)*0.15)
//        let red = val >= 0 ? val : 0
//        return UIColor(displayP3Red: red, green: 0, blue: 0, alpha: 0.85)
        return UIColor(displayP3Red: 0.9, green: 0.9, blue: 1, alpha: 1)
    }
    
    override func viewDidLoad() {
        let newItem = TodoItem()
        newItem.title = "First Item"
        newItem.isCompleted = true
        itemArray.append(newItem)
//        if let items = defaults.array(forKey: todoArrayKey) as? [String]{
//            self.itemArray = items
//        }
        loadItems()
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK: Create tableview datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }

    //This called is the startup of the app, or whenever the view is reloaded
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todoItem = itemArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = todoItem.title
        cell.backgroundColor = UIColor.lightGray
        cell.accessoryType = todoItem.isCompleted ? .checkmark : .none
        return cell
    }
    
    //MARK: Create TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].isCompleted = !itemArray[indexPath.row].isCompleted
        saveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        var textField = UITextField()
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when user clicks the add item button on the UI alert
            let item = TodoItem()
            item.title = textField.text!
            self.itemArray.append(item)
            self.saveItems()
//            self.defaults.set(self.itemArray, forKey: self.todoArrayKey)
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }

    fileprivate func loadItems(){
        do {
            if let data = try? Data(contentsOf: dataFilePath!){
                let decoder = PropertyListDecoder()
                itemArray = try decoder.decode([TodoItem].self, from: data)
            }
        } catch {
            
        }
        
    }
    //MARK: Create save data method
    fileprivate func saveItems(){
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("error encoding array \(error)")
        }
    }
}



