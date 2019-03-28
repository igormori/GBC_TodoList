

import UIKit
import CoreData

var categories: [Category] = []

class ListViewController: UITableViewController, ReloadTableProtocol {

    @IBOutlet var table: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
        
        do {
            categories = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addList(_ sender: UIBarButtonItem) {
        addCategory()
    }
    
    // Generate the popup that asks the user for create a new super task
    func addCategory() {
        
        let title = "New List Name"
        let message = ""
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Add", style: .default) { action in
            if let field = alertController.textFields?[0] {
                if (field.text!.count < 1) {
                    self.invalidInputAlert()
                    return
                }
                // save field
                self.save(title: field.text!)
                self.table.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addTextField { textField in
            textField.placeholder = "Name"
            textField.autocapitalizationType = UITextAutocapitalizationType.words
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    // validate if the popup field is empty
    func invalidInputAlert() {
        
        let title = "Missing List Name"
        let message = "Please enter a valid list name. Name must contain at least one letter."
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "OK", style: .cancel) { action in
            self.addCategory()
        }
        
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
    }

    // Enables swipe to delete feature
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
    }
    
    // Removes deleted row from the categories list and deletes the row from the table
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let category = categories[indexPath.row]
        
        managedContext.delete(category)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        categories.remove(at: indexPath.row)
        table.deleteRows(at: [indexPath], with: .fade)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
    
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
        return categories.count
    }

    // when the task is over due
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let text = category.value(forKeyPath: "title") as? String
        
        if containsExpiredTask(category) {
            let expired = ("! \t")
            cell.textLabel?.text = expired.appending(text!)
            cell.textLabel?.textColor = UIColor.red
        } else {
            cell.textLabel?.text = text
            cell.textLabel?.textColor = UIColor.black
        }
        
        return cell
    }
    
    
    func containsExpiredTask(_ category: Category) -> Bool {
        
        for t in (category.tasks?.array)! {
            if ((t as! Task).dueDate! as Date) < Date() {
                return true
            }
        }
        return false
    }
    
    func reloadTable() {
        self.table.reloadData()
    }
    
    // save on coredata
    func save(title: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Category", in: managedContext)!
        
        let category = Category(entity: entity, insertInto: managedContext)
        
        category.setValue(title, forKeyPath: "title")
        
        categories.append(category)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }


    
    // MARK: - Navigation
    // to navegate to another page after click
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        
        guard let tasksTableViewController = segue.destination as? TasksTableViewController
            else { return }
        guard let indexPath = self.tableView.indexPathForSelectedRow
            else { return }
        tasksTableViewController.category = categories[indexPath.row]
        tasksTableViewController.delegate = self
        
    }
    

}
