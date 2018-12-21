//
//  ViewController.swift
//  Todoey
//
//  Created by Tyrus Sonneborn on 12/17/18.
//  Copyright © 2018 Tyrus Sonneborn. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    var itemArray = [TodoItem]()
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getColor() -> UIColor{
        return UIColor(displayP3Red: 0.9, green: 0.9, blue: 1, alpha: 0.75)
    }
    
    override func viewDidLoad() {
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
        cell.backgroundColor = getColor()
        cell.accessoryType = todoItem.isComplete ? .checkmark : .none
        return cell
    }
    
    //MARK: Create TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].isComplete = !itemArray[indexPath.row].isComplete
        
        //MARK: Delete
//        let itemRemoved = itemArray.remove(at: indexPath.row)
//        context.delete(itemRemoved)
        saveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        var textField = UITextField()
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.addTodoItem(from: textField)
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }

    //Create
    fileprivate func addTodoItem(from textField: UITextField){
        //What will happen when user clicks the add item button on the UI alert
        if textField.text?.count == 0{
            let alert = UIAlertController(title: "Category name cannot be empty", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Okay", style: .default)
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }
        let item = TodoItem(context: self.context)
        item.title = textField.text!
        item.isComplete = false
        item.parentCategory = self.selectedCategory
        self.itemArray.append(item)
        self.saveItems()
        self.tableView.reloadData()
    }
    
    
    //Create
    fileprivate func saveItems(){
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    
    //Read in items, by default grab everything
    func loadItems(with request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest(), predicate: NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch  {
            print("error fetching data from context \(error)")
        }
        self.tableView.reloadData()
    }
}

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        
        //NS predicate
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            //Should no longer the thing that is selected
            
            //Managers assign project, run the method on the main queue when it's ready 
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            
        } else {
            searchBarSearchButtonClicked(searchBar)
        }
    }
}

