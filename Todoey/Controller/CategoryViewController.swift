//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Tyrus Sonneborn on 12/20/18.
//  Copyright © 2018 Tyrus Sonneborn. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        loadCategories()
        super.viewDidLoad()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        var textField = UITextField()
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            self.addCategory(from: textField)
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func addCategory(from textField: UITextField){
        //What will happen when user clicks the add item button on the UI alert
        if textField.text?.count == 0{
            let alert = UIAlertController(title: "Category name cannot be empty", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Okay", style: .default)
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }
        
        let category = Category(context: self.context)
        category.name = textField.text
        
        categoryArray.append(category)
        self.saveCategories()
        self.tableView.reloadData()
    }
    

    
    //Mark: TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categoryArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = category.name
        return cell
    }
    
    //Mark: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        //The current row that is selected
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //Mark: - Data Manipulation
    
    fileprivate func saveCategories(){
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    fileprivate func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            categoryArray = try context.fetch(request)
        } catch  {
            print("error fetching categories from context \(error)")
        }
        self.tableView.reloadData()
    }
}
