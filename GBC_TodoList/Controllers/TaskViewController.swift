
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
        addToolbars()
    }

    func addToolbars() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let dateToolbar = UIToolbar()
        dateToolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.donePressed))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
    
        detailsText.inputAccessoryView = toolbar
        dueDateField.inputAccessoryView = dateToolbar
        
        dueDateField.inputView = datePicker
    }
    
    @objc func donePressed() {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Loads task details
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    */

}
