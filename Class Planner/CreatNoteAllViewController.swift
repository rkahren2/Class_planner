/***********************************************************************
PROGRAM: 		Class Planner
AUTHOR: 		Robert Kahren II
LOGON ID		Z1691801
DUE DATE:		April 30, 2015 at 11:59pm

FUNCTION:	This program runs on iphone and provides students with a way to track thier classes, assignments, and
notes.  It provides a way for the student to enter the information about thier clasees, including the days and
times it meets, who instructor and TA and thier emails. The student can also create assignments and notes for
thier classes.  It also allows them to email tier instructor or TA from the app.

INPUT: 		The program revieces input from the user via the deceive's touch screen

OUTPUT:		The program displys information to the user via the deceive's touch screen
**************************************************************************/
import UIKit
import CoreData

class CreatNoteAllViewController: UIViewController, NSFetchedResultsControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var classPickerView: UIPickerView!           //picker for class
    @IBOutlet weak var noteTitleTextField: UITextField!         //enter note title
    @IBOutlet weak var noteTextView: UITextView!                //enter note
    
    var courses:[Course] = []                                   //list of class
    var courseName:String!                                      //name of class
    var note:Note!                                              //note to be created
    
    //create managedObjectContext, fetechResultController, for retriving and saving CoreData
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var fetchResultController:NSFetchedResultsController!

    /********************************************************************************
    FUNCTION:		 override func viewDidLoad()
    
    ARGUMENTS:		This function recieves no arguments
    
    RETURNS:		The function has no return value
    
    NOTES:			The function is called after the controller’s view is loaded into memory. It poplates the UI elements of the view,
    and retrives coures from coreData
    ************************************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)

        // setpickerview delegates
        classPickerView.dataSource = self
        classPickerView.delegate = self
        //create Fetech Request and sortDescriptor
        var fetchRequest = NSFetchRequest(entityName: "Course")
        let sortDescriptor = NSSortDescriptor(key: "courseName", ascending: true)
        
        //Set the sortDescriptor on the fetch request
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //assign FetchRequest to FetchRequestController and assign it's delegate
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        //retirve courses from CoreData
        var e: NSError?
        var result = fetchResultController.performFetch(&e)
        courses = fetchResultController.fetchedObjects as! [Course]
        
        if result != true{
            println(e?.localizedDescription)
        }
        //reload pickerview and set inital class name
        classPickerView.reloadAllComponents()
        courseName = courses[0].courseName

    }
    /********************************************************************************
    FUNCTION:		override func didReceiveMemoryWarning()
    
    ARGUMENTS:		This function recieves no arguments
    
    RETURNS:		The function has no return value
    
    NOTES:			This function is called by the system when the app receives a memory warning.
    ************************************************************************************/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Delegates and data sources for PickerView
    /********************************************************************************
    FUNCTION:		func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    
    ARGUMENTS:		pickerView: UIPickerView, a picker view requesting this information.
    
    RETURNS:		The function returns a NSInteger reperseting the number of sections in the picker
    
    NOTES:			This function returns the number of sections in the picker, in this case 1
    ************************************************************************************/
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    /********************************************************************************
    FUNCTION:		func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    
    ARGUMENTS:		pickerView: UIPickerView, The picker view requesting this information, section: Int, index number identifying a section in
    picker.
    
    RETURNS:		The function returns a NSInteger repersenting the number of rows in the section
    
    NOTES:			This function gets the number of courses and returns it as the number of rows for the picker
    ************************************************************************************/
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return courses.count
    }
    /********************************************************************************
    FUNCTION:		func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    
    ARGUMENTS:		pickerView: UIPickerView, the picker requesting the component, component: Int, int locating a row in
    picker
    
    
    RETURNS:		The function returns an string that the picker can use for the specified row
    
    NOTES:			This function returns a string for the picker to use in a row
    ************************************************************************************/
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return courses[row].courseName
    }
    /********************************************************************************
    FUNCTION:		func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    
    ARGUMENTS:		pickerView: UIPickerView, the picker requesting the component, row: Int, int locating a row that
                    was selected, component: Int the component selected
    
    
    RETURNS:		The function has no return function
    
    NOTES:			This function is called when the picker view selection is changed
    ************************************************************************************/
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        courseName = courses[row].courseName
    }
    
    // Mark - Buttons
    /********************************************************************************
    FUNCTION:		 @IBAction func SaveButton(sender: AnyObject)
    
    ARGUMENTS:		sender: AnyObject, the oject that called the function
    
    RETURNS:		The function has returns an IBaction.
    
    NOTES:			This function is called when the save button is pressed
    ************************************************************************************/
    @IBAction func saveButton(sender: AnyObject) {
        saveNote()
        
    }

    /********************************************************************************
    FUNCTION:		 @IBAction func cancelButton(sender: AnyObject)
    
    ARGUMENTS:		sender: AnyObject, the oject that called the function
    
    RETURNS:		The function has returns an IBaction.
    
    NOTES:			This function is called when the cancel button is pressed
    ************************************************************************************/
    @IBAction func cancelButton(sender: AnyObject) {
        //alert view to warn the user before leaving the screen
        var saveAlert = UIAlertController(title: "Continue?", message: "Continuing without saving will discard this note", preferredStyle: UIAlertControllerStyle.Alert)
        //save class if user chooses to
        saveAlert.addAction(UIAlertAction(title: "Save", style: .Default, handler:
            {
                (action: UIAlertAction!) in
                self.saveNote()
        }))
        //leave screen if user chooses to
        saveAlert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: {
            (action: UIAlertAction!) in
            self.performSegueWithIdentifier("unwindToAllNotes", sender: self)
        }))
        
        //display alert
        presentViewController(saveAlert, animated: true, completion: nil)
        
    }
    /********************************************************************************
    FUNCTION:		func save()
    
    ARGUMENTS:		The function receives no arguments
    
    RETURNS:		The function has no return value
    
    NOTES:			This function saves the changes to coredata
    ************************************************************************************/
    func save() {
        var error : NSError?
        if(managedObjectContext!.save(&error) ) {
            println(error?.localizedDescription)
        }
    }
    /********************************************************************************
    FUNCTION:		 func saveNote()
    
    ARGUMENTS:		this function receives no arguments
    
    RETURNS:		this function has no return value
    
    NOTES:			This function validates and creates the new note and saves it to CoreData
    ************************************************************************************/
    func saveNote(){
        // Form validation
        var errorField = ""
        
        if noteTitleTextField.text == "" {
            errorField = "Note Title"
        }
        //display alert if error
        if errorField != "" {
            
            let alertController = UIAlertController(title: "Error Occurs", message: "Missing entry for " + errorField + ". Please give your note a title", preferredStyle: .Alert)
            let doneAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            
            alertController.addAction(doneAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            
            return
        }
        //create note
        note = NSEntityDescription.insertNewObjectForEntityForName("Note", inManagedObjectContext: managedObjectContext!) as! Note
        //set note properies
        note.courseName = courseName
        note.noteTitle = noteTitleTextField.text
        note.noteContent = noteTextView.text
        //save note
        var e: NSError?
        if managedObjectContext?.save(&e) != true {
            println("insert error: \(e!.localizedDescription)")
            return
        }
        save()
        
         //display save confrimation and perform segue
        let alertController = UIAlertController(title: "Note Saved", message: noteTitleTextField.text + " has been saved.", preferredStyle: .Alert)
        let doneAction = UIAlertAction(title: "OK", style: .Default, handler: {
            (action: UIAlertAction!) in
                self.performSegueWithIdentifier("unwindToAllNotes", sender: self)
            
        })
        alertController.addAction(doneAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)

    }
    
    /********************************************************************************
    FUNCTION:		 func DismissKeyboard()
    
    ARGUMENTS:		this function receives no arguments
    
    RETURNS:		this function has no return value
    
    NOTES:			This function dismisses the keyboard
    ************************************************************************************/
    func DismissKeyboard(){
        view.endEditing(true)
    }
}



