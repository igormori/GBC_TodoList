//
//  TasksTableViewController.swift
//  List Tracker
//
//  Created by David Para on 3/5/17.
//  Copyright © 2017 DePaul University. All rights reserved.
//

import UIKit
import MessageUI
import CoreData

class TasksTableViewController: UITableViewController, NewTaskProtocol, ReloadTableProtocol, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet var table: UITableView!
    
    var category: Category?
    var task: Task?
    var delegate: ReloadTableProtocol?
    
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = category?.title
    }
    
    @IBAction func addTaskButtonPressed(_ sender: UIBarButtonItem) {
        addTask()
    }
    
    
    // Generate the popup that asks the user for new category name
    func addTask() {
        let newTaskViewController = storyboard!.instantiateViewController(withIdentifier: "Add New Task") as! AddNewTaskViewController
        newTaskViewController.delegate = self
        self.navigationController?.pushViewController(newTaskViewController, animated: true)
    }
    
    
    // MESSAGING
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareListButtonPressed(_ sender: UIBarButtonItem) {
        if MFMessageComposeViewController.canSendText() {
            let controller = MFMessageComposeViewController()
            let message = category?.tasks?.array.flatMap({
                (t) -> String in (t as! Task).title!
            })
            
            controller.body = (category?.title)! + ": " + (message)!
            controller.recipients = []
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    
    
    // Delete Cell
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
    }
    
    // Removes deleted row from the categories list and deletes the row from the table
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(category?.tasks![indexPath.row] as! Task)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        table.deleteRows(at: [indexPath], with: .fade)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    // TABLE VIEW
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if let count = category?.tasks?.count {
            return count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let task = category?.tasks![indexPath.row] as! Task
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var dueDate = ""
        var
        dateString = ""
        
        if dueToday(task.dueDate!) {
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            dateString = dateFormatter.string(from: task.dueDate! as Date)
            dueDate = "Was due: \(dateString)"
        } else if pastDue(task.dueDate!) {
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            dateString = dateFormatter.string(from: task.dueDate! as Date)
            dueDate = "Was due: \(dateString)"
        } else {
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            dateString = dateFormatter.string(from: task.dueDate! as Date)
            dueDate = "Due: \(dateString)"
        }
        
//        dateFormatter.dateFormat = "MM/dd/YYYY"
        
        
        
        
        cell.textLabel?.text = task.title
        cell.detailTextLabel?.text = dueDate
        
        if pastDue(task.dueDate!) {
            cell.detailTextLabel?.textColor = UIColor.red
        } else {
            cell.detailTextLabel?.textColor = UIColor.black
        }
        
        // Configure the cell...

        return cell
    }
    
    // DUE DATES
    func pastDue(_ date: NSDate) -> Bool {
        if (date as Date) < Date() {
           return true
        }
        return false
    }
    
    func dueToday(_ date: NSDate) -> Bool {
        dateFormatter.dateStyle = .short
        if dateFormatter.string(from: date as Date) == dateFormatter.string(from: Date()) {
            return true
        }
        return false
    }
    
    
    // CREATE NEW TASK
    func setTask(title: String, details: String, dueDate: Date) {
        self.createTask(title: title, details: details, dueDate: dueDate)
        self.table.reloadData()
    }
    
    func createTask(title: String, details: String, dueDate: Date) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)!
        
        let task = Task(entity: entity, insertInto: managedContext)
        
        task.setValue(title, forKey: "title")
        task.setValue(details, forKey: "details")
        task.setValue(dueDate, forKey: "dueDate")
        
        category?.addToTasks(task)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func reloadTable() {
        self.table.reloadData()
        delegate?.reloadTable()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        guard let taskViewController = segue.destination as? TaskViewController
            else { return }
        guard let indexPath = self.tableView.indexPathForSelectedRow
            else { return }
        taskViewController.task = category?.tasks![indexPath.row] as? Task
        taskViewController.delegate = self
    }

}
