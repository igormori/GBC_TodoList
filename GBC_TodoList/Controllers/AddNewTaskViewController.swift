
import UIKit

protocol NewTaskProtocol {
    func setTask(title: String, details: String, dueDate: Date)
}

class AddNewTaskViewController: UIViewController {
    
    var date: Date?
    var task: Task?
    var delegate: NewTaskProtocol?

    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var dueDateField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // Complete
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
            
    }
    */

}
