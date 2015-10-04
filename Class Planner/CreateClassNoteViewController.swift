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

class CreateClassNoteViewController: UIViewController {

    @IBOutlet weak var classNameLabel: UILabel!                 //display class name
    @IBOutlet weak var noteTitleTextField: UITextField!         //enter note title
    @IBOutlet weak var noteTextView: UITextView!                //enter note
    
    var courseName:String!                                      //class name
    var createFlag:Bool!                                        //flag indicating if this is a new note
    var note:Note!                                              //note being created/edited
    
    //create managedObjectContext for saving note to coredata
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    /********************************************************************************
    FUNCTION:		 override func viewDidLoad()
    
    ARGUMENTS:		This function recieves no arguments
    
    RETURNS:		The function has no return value
    
    NOTES:			The function is called after the controller’s view is loaded into memory. It poplates the UI elements of the view
    ************************************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)

        //set class name
        self.classNameLabel.text = courseName
        //if new note
        if(createFlag == true)
        {
            self.navigationItem.title = "Create Note"
        }
        //if edit note
        else
        {
            self.navigationItem.title = "Edit Note"
            self.noteTitleTextField.text = note.noteTitle
            self.noteTextView.text = note.noteContent
        }
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
    

    
    
    // MARK: - Buttons
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
        var errorField = ""
        
        //if editing a note
        if createFlag == false
        {
            //alert view to warn the user before leaving the screen
            var saveAlert = UIAlertController(title: "Continue?", message: "Continuing without saving will discard all changes", preferredStyle: UIAlertControllerStyle.Alert)
            //save class if user chooses to
            saveAlert.addAction(UIAlertAction(title: "Save", style: .Default, handler: {
                (action: UIAlertAction!) in
                self.saveNote()
            }))
            //leave screen if user chooses to
            saveAlert.addAction(UIAlertAction(title: "Continue", style: .Default, handler:
                    {
                        (action: UIAlertAction!) in
                        self.performSegueWithIdentifier("unwindToClassNote", sender: self)
                    }))
                //display alert
                presentViewController(saveAlert, animated: true, completion: nil)
        //if new note
        }else
        {
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
                self.performSegueWithIdentifier("unwindToClassNoteList", sender: self)
            }))
            //display alert
            presentViewController(saveAlert, animated: true, completion: nil)
            

        }
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
        
        if errorField != "" {
            
            let alertController = UIAlertController(title: "Error Occurs", message: "Missing entry for " + errorField + ". Please give your note a title", preferredStyle: .Alert)
            let doneAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            
            alertController.addAction(doneAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        //if editing a note
        if(createFlag == false)
        {
            managedObjectContext?.deleteObject(note)
            save()
        }
        //create note
        note = NSEntityDescription.insertNewObjectForEntityForName("Note", inManagedObjectContext: managedObjectContext!) as! Note
        //set note properies
        note.courseName = classNameLabel.text
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
            if self.createFlag == false
            {
                self.performSegueWithIdentifier("unwindToClassNote", sender: self)
            }else
            {
                self.performSegueWithIdentifier("unwindToClassNoteList", sender: self)
            }

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
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


    
   
    // MARK: - Navigation
    /********************************************************************************
    FUNCTION:		override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    
    ARGUMENTS:		segue: UIStoryboardSegue, the segue containing information about the view controllers involved in the segue,
    ender: AnyObject!, the object that initiated the segue.
    
    RETURNS:		The function has no return value
    
    NOTES:			This function notifies the view controller that a segue is about to be performed and can be used to pass relevant data to
    the new view controller.
    ************************************************************************************/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        //if segue is unwindToClassNote
        if segue.identifier == "unwindToClassNote" {
            let destinationController = segue.destinationViewController as! ViewNoteViewController
            
            // Passing the note object to the detail view
            destinationController.note = note
            
        }

    }

    

}
