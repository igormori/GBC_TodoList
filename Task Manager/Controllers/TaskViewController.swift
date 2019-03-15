//
//  TaskViewController.swift
//  List Tracker
//
//  Created by David Para on 3/8/17.
//  Copyright © 2017 DePaul University. All rights reserved.
//

import UIKit

protocol ReloadTableProtocol {
    func reloadTable()
}

class TaskViewController: UIViewController {

    var task: Task?
    var delegate: ReloadTableProtocol?
    
    @IBOutlet weak var dueDateField: UITextField!
    @IBOutlet weak var detailsText: UITextView!
    
    let datePicker = UIDatePicker()
    let formattedDate = DateFormatter()
    
    let grayColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
    
    @IBAction func dropDownPressed(_ sender: UIButton) {
        dueDateField.becomeFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsText.layer.borderWidth = 0.5
        detailsText.layer.borderColor = grayColor.cgColor
        detailsText.layer.cornerRadius = 5.0
        
        formattedDate.dateStyle = .medium
        formattedDate.timeStyle = .short
        
        createDatePicker()
        addToolbars()
        
        // Do any additional setup after loading the view.
    }

    func addToolbars() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let dateToolbar = UIToolbar()
        dateToolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.donePressed))
        let dateDoneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.dateDonePressed))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        dateToolbar.setItems([flexSpace, dateDoneButton], animated: true)
        
        detailsText.inputAccessoryView = toolbar
        dueDateField.inputAccessoryView = dateToolbar
        
        dueDateField.inputView = datePicker
    }
    
    func createDatePicker() {
        datePicker.datePickerMode = .dateAndTime
        datePicker.minuteInterval = 15
        datePicker.date = task?.dueDate! as! Date
        dueDateField.text = "\(datePicker.date)"
    }
    
    @objc func donePressed() {
        self.view.endEditing(true)
    }
    
    @objc func dateDonePressed() {
        
        dueDateField.text = formattedDate.string(from: datePicker.date)
        
        task?.dueDate = datePicker.date as NSDate as Date
        
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Loads task details
    override func viewWillAppear(_ animated: Bool) {
        if let t = task {
            navigationItem.title = t.title
            dueDateField.text = formattedDate.string(from: t.dueDate! as Date)
            detailsText.text = t.details
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if let detailsEdited = detailsText.text {
            task?.details = detailsEdited
        }
        
        delegate?.reloadTable()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    */

}
