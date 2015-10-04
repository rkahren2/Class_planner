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

class ViewNoteViewController: UIViewController {

    @IBOutlet weak var courseNameLabel: UILabel!            //display course name
    @IBOutlet weak var noteTextView: UITextView!            //display note
    
    var note:Note!                                          //note to be displayed
    /********************************************************************************
    FUNCTION:		 override func viewDidLoad()
    
    ARGUMENTS:		This function recieves no arguments
    
    RETURNS:		The function has no return value
    
    NOTES:			The function is called after the controller’s view is loaded into memory. It populates the UI elements    ************************************************************************************/

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        courseNameLabel.text = note.courseName
        self.navigationItem.title = note.noteTitle
        noteTextView.text = note.noteContent
        
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
        //if segue is editNote
        if segue.identifier == "editNote" {
            let destinationController = segue.destinationViewController as! CreateClassNoteViewController
            
            // Passing the note object, create flag, and class name to the edit view
            destinationController.note = note
            destinationController.createFlag = false
            destinationController.courseName = note.courseName
            
        }
    }
    /********************************************************************************
    FUNCTION:		@IBAction func unwindToAllAssignment(segue:UIStoryboardSegue)
    
    ARGUMENTS:		segue: UIStoryboardSegue, the segue containing information about the view controllers involved in the segue,
    
    RETURNS:		The function has no return value
    
    NOTES:			This function is called when a segue "unwindToAllAssignment" is performed
    ************************************************************************************/
    @IBAction func unwindToClassNote(segue:UIStoryboardSegue) {
        courseNameLabel.text = note.courseName
        self.navigationItem.title = note.noteTitle
        noteTextView.text = note.noteContent
    }


}
