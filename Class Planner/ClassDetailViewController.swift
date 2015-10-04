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
import MessageUI

class ClassDetailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var course:Course!              //class to be viewed
    
    @IBOutlet weak var daysOfWeekLabel: UILabel!                //display days the class meets
    @IBOutlet weak var startTimeLabel: UILabel!                 //display time class starts
    @IBOutlet weak var endTimeLabel: UILabel!                   //display time class ends
    @IBOutlet weak var instructorNameLabel: UILabel!            //display instructor's name
    @IBOutlet weak var instructorEmailButton: UIButton!         //button to email instructor
    @IBOutlet weak var instructorPhoneButton: UIButton!         //button to call instructor
    @IBOutlet weak var taLabel: UILabel!                        //label for TA's Name
    @IBOutlet weak var taNameLabel: UILabel!                    //TA's Name
    @IBOutlet weak var taEmailButton: UIButton!                 //button to email TA
    @IBOutlet weak var noTALabel: UILabel!                      //no TA message
   
    
    /********************************************************************************
    FUNCTION:		 override func viewDidLoad()
    
    ARGUMENTS:		This function recieves no arguments
    
    RETURNS:		The function has no return value
    
    NOTES:			The function is called after the controller’s view is loaded into memory. It poplates the UI elements of the view
    ************************************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //popluar UI fields
        self.navigationItem.title = course.courseName
        startTimeLabel.text = course.startTime
        endTimeLabel.text = course.endTime
        instructorNameLabel.text = course.instructorName
        let instructorEmail = ("Email \(course.instructorName)")
        instructorEmailButton.setTitle(instructorEmail, forState: UIControlState.Normal)
        let instructorPhone = ("Call \(course.instructorName)")
        instructorPhoneButton.setTitle(instructorPhone, forState: UIControlState.Normal)
        daysOfWeekLabel.text = ""
        
        //populate the days of the week
        if((course.mondayBool) == true)
        {
            daysOfWeekLabel.text = "Monday"
        }
        if((course.tuesdayBool) == true)
        {
            let days = daysOfWeekLabel.text
            let thisDay = "Tuesday"
            if(days != "")
            {
                let coma = ", "
                daysOfWeekLabel.text = days! + coma + thisDay
                
            }else
            {
                daysOfWeekLabel.text = days! + thisDay
            }
        }
        if((course.wednesdayBool) == true)
        {
            let days = daysOfWeekLabel.text
            let thisDay = "Wednesday"
            if(days != "")
            {
                let coma = ", "
                daysOfWeekLabel.text = days! + coma + thisDay
                
            }else
            {
                daysOfWeekLabel.text = days! + thisDay
            }

        }
        if((course.thursdayBool) == true)
        {
            let days = daysOfWeekLabel.text
            let thisDay = "Thursday"
            if(days != "")
            {
                let coma = ", "
                daysOfWeekLabel.text = days! + coma + thisDay
                
            }else
            {
                daysOfWeekLabel.text = days! + thisDay
            }
        }
        if((course.fridayBool) == true)
        {
            let days = daysOfWeekLabel.text
            let thisDay = "Friday"
            if(days != "")
            {
                let coma = ", "
                daysOfWeekLabel.text = days! + coma + thisDay
                
            }else
            {
                daysOfWeekLabel.text = days! + thisDay
            }
        }
        if((course.saturdayBool) == true)
        {
            let days = daysOfWeekLabel.text
            let thisDay = "Saturday"
            if(days != "")
            {
                let coma = ", "
                daysOfWeekLabel.text = days! + coma + thisDay
                
            }else
            {
                daysOfWeekLabel.text = days! + thisDay
            }
       }
        //if no TA, display no TA message
        if(course.taName == "")
        {
            taLabel.hidden = true
            taNameLabel.hidden = true
            taEmailButton.hidden = true
            noTALabel.hidden = false
        //otherwise display TA information
        }else
        {
            taNameLabel.text = course.taName
            let taEmail = ("Email \(course.taName)")
            taEmailButton.setTitle(taEmail, forState: UIControlState.Normal)
            
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
    
    //MARK: - Buttons
    /********************************************************************************
    FUNCTION:		  @IBAction func instructorEmailButton(sender: AnyObject)
    
    ARGUMENTS:		sender: AnyObject, the oject that called the function
    
    RETURNS:		The function has returns an IBaction.
    
    NOTES:			This function is called when the email Instructor button is pressed
    ************************************************************************************/
    @IBAction func instructorEmailButton(sender: AnyObject) {
        
        //create Mail Compose View Controller
        let mailComposerVC = MFMailComposeViewController()
        //set delegate and properties
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([course.instructorEmail])
        mailComposerVC.setSubject(course.courseName)
        mailComposerVC.setMessageBody(("To \(course.instructorName)"), isHTML: false)
        //present view controller
        self.presentViewController(mailComposerVC, animated: true, completion: nil)
    }
   
    /********************************************************************************
    FUNCTION:		  @IBAction func instructorEmailButton(sender: AnyObject)
    
    ARGUMENTS:		sender: AnyObject, the oject that called the function
    
    RETURNS:		The function has returns an IBaction.
    
    NOTES:			This function is called when the call Instructor button is pressed
    ************************************************************************************/
    @IBAction func instructorPhoneButton(sender: AnyObject) {
        //build URL for dailing
        let pre = "tel://"
        let phone = pre + course.instructorPhone
        //place call with shared  application
        UIApplication.sharedApplication().openURL(NSURL(string: phone)!)
        println("Calling \(phone)")
        
    }
    
    /********************************************************************************
    FUNCTION:		  @IBAction func instructorEmailButton(sender: AnyObject)
    
    ARGUMENTS:		sender: AnyObject, the oject that called the function
    
    RETURNS:		The function has returns an IBaction.
    
    NOTES:			This function is called when the email TA button is pressed
    ************************************************************************************/
    @IBAction func taEmailButton(sender: AnyObject) {
        //create Mail Compose View Controller
        let mailComposerVC = MFMailComposeViewController()
        //set delegate and properties
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([course.taEmail])
        mailComposerVC.setSubject(course.courseName)
        mailComposerVC.setMessageBody(("To \(course.taName)"), isHTML: false)
        //present view controller
        self.presentViewController(mailComposerVC, animated: true, completion: nil)

    }
    
    /********************************************************************************
    FUNCTION:		  func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!)
    
    ARGUMENTS:		controller: MFMailComposeViewController, view controller managing the mail, result: MFMailComposeResult,results of the user's actions ,error: NSError, error object if an error occurs
    
    RETURNS:		The function has no return value.
    
    NOTES:			This function is called when the mailcomposer completes
    ************************************************************************************/
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
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
        //if segue is showClassNotes
        if segue.identifier == "showClassNotes" {
                let courseName = course.courseName
                let destinationController = segue.destinationViewController as! ClassNotesTableViewController
                
                // Passing the class name to the detail view
                destinationController.courseName = courseName
            
        }
        //if segue is showClass Asignments
        if segue.identifier == "showClassAssignments" {
            let courseName = course.courseName
            let destinationController = segue.destinationViewController as! ClassAssignmentsTableViewController
            
            // Passing the class name to the detail view
            destinationController.courseName = courseName
            
        }

    }

}
