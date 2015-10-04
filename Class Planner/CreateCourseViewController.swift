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
import EventKit

class CreateCourseViewController: UIViewController {
    
    @IBOutlet weak var courseNameTextField: UITextField!                //for entering the name of the class
    @IBOutlet weak var instructorNameTextField: UITextField!            //for entering the name eof the instructor
    @IBOutlet weak var instructorPhoneTextField: UITextField!           //for entering instructor's phone number
    @IBOutlet weak var instructorEmailTextField: UITextField!           //for entering the instructor's email
    @IBOutlet weak var taNameTextField: UITextField!                    //for entering the TA's nmae
    @IBOutlet weak var taEmailTextField: UITextField!                   //for entering the TA's email
    
    @IBOutlet weak var firstDayPicker: UIDatePicker!                    //for picking first day of class
    @IBOutlet weak var lastDayPicker: UIDatePicker!                     //for picking the last day of class
    @IBOutlet weak var startTimePicker: UIDatePicker!                   //for picking the start time of class
    @IBOutlet weak var stopTimePicker: UIDatePicker!                    //for picking the end time of class
    
    
    @IBOutlet weak var mondaySwitch: UISwitch!                          //selecting Monday as a day the class meets
    @IBOutlet weak var tuesdaySwitch: UISwitch!                         //selecting Tuesday as a day the class meets
    @IBOutlet weak var wednesdaySwitch: UISwitch!                       //selecting Wednesday as a day the class meets
    @IBOutlet weak var thursdaySwitch: UISwitch!                        //selecting Thursday as a day the class meets
    @IBOutlet weak var fridaySwitch: UISwitch!                          //selecting Friday as a day the class meets
    @IBOutlet weak var saturdaySwitch: UISwitch!                        //selecting Saturday as a day the class meets

    
    var course:Course!              //course to be added
    var boolValue = true            //bool value of true

    /********************************************************************************
    FUNCTION:		 override func viewDidLoad()
    
    ARGUMENTS:		This function recieves no arguments
    
    RETURNS:		The function has no return value
    
    NOTES:			The function is called after the controller’s view is loaded into memory. It sets up for dissmising the keyboard on taps
    ************************************************************************************/

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Looks for single or multiple taps.
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    /********************************************************************************
    FUNCTION:		override func viewWillAppear(animated: Bool)
    
    ARGUMENTS:		animated: Bool, bool to indicate if it should be animated
    
    RETURNS:		The function has no return value
    
    NOTES:			This function is called when the view is about to appear on screen
    ************************************************************************************/
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //set navigational bar colors
        var nav = self.navigationController?.navigationBar
        nav?.barTintColor = UIColor.blueColor()
        nav?.tintColor = UIColor.whiteColor()
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        UITabBar.appearance().barTintColor = UIColor.blueColor()
        
        
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
    
    /********************************************************************************
    FUNCTION:		 @IBAction func SaveButton(sender: AnyObject)
    
    ARGUMENTS:		sender: AnyObject, the oject that called the function
    
    RETURNS:		The function has returns an IBaction.
    
    NOTES:			This function is called when the save button is pressed  
    ************************************************************************************/
    @IBAction func SaveButton(sender: AnyObject) {
        saveCourse()
    }

    
    /********************************************************************************
    FUNCTION:		 @IBAction func cancelButton(sender: AnyObject)
    
    ARGUMENTS:		sender: AnyObject, the oject that called the function
    
    RETURNS:		The function has returns an IBaction.
    
    NOTES:			This function is called when the cancel button is pressed
    ************************************************************************************/
    @IBAction func cancelButton(sender: AnyObject) {
        
        //alert view to warn the user before leaving the screen
        var saveAlert = UIAlertController(title: "Continue?", message: "Continuing without saving will discard this class", preferredStyle: UIAlertControllerStyle.Alert)
        
        //save class if user chooses to
        saveAlert.addAction(UIAlertAction(title: "Save", style: .Default, handler:
            {
                (action: UIAlertAction!) in
                self.saveCourse()
        }))
        
        //leave screen if user chooses to
        saveAlert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: {
            (action: UIAlertAction!) in
            self.performSegueWithIdentifier("unwindToCourses", sender: self)
        }))

        //display alert
        presentViewController(saveAlert, animated: true, completion: nil)
        
    }
    
    /********************************************************************************
    FUNCTION:		 func saveCourse()
    
    ARGUMENTS:		this function receives no arguments
    
    RETURNS:		this function has no return value
    
    NOTES:			This function validates and creates the new class and saves it to CoreData
    ************************************************************************************/
    func saveCourse(){
        // Form validation
        var errorField = ""
        
        if courseNameTextField.text == "" {
            errorField = "Class name is missing"
        } else if instructorNameTextField.text == "" {
            errorField = "Instructor name is missing"
        } else if instructorPhoneTextField.text == "" {
            errorField = "Instruction phone is missing"
        } else if instructorEmailTextField.text == "" {
            errorField = "Instruction email is missing"
        }else if lastDayPicker.date.compare(firstDayPicker.date) == .OrderedAscending{
            errorField = "Last day of class is before first day"
        }
        
        //if error display error alert and return from function
        if errorField != "" {
            
            let alertController = UIAlertController(title: "Error Occurs", message: "The following problem occured in creating your class " + errorField + ". Please check all non-optional fields.", preferredStyle: .Alert)
            let doneAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            
            alertController.addAction(doneAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        
        //convert date and times to strings
        var dateFormatter = NSDateFormatter()
        var timeFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        var startDate = dateFormatter.stringFromDate(firstDayPicker.date)
        var endDate = dateFormatter.stringFromDate(lastDayPicker.date)
        
        var startTime = timeFormatter.stringFromDate(startTimePicker.date)
        var endTime = timeFormatter.stringFromDate(stopTimePicker.date)
       
        //create managedObjectContext for storing in CoreData
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext {
            
            //create course to store
            course = NSEntityDescription.insertNewObjectForEntityForName("Course", inManagedObjectContext: managedObjectContext) as! Course
            
            //assign values of the new course
            course.courseName = courseNameTextField.text
            course.startDate = startDate
            course.endDate = endDate
            course.startTime = startTime
            course.endTime = endTime
            course.mondayBool = mondaySwitch.on
            course.tuesdayBool = tuesdaySwitch.on
            course.wednesdayBool = wednesdaySwitch.on
            course.thursdayBool = thursdaySwitch.on
            course.fridayBool = fridaySwitch.on
            course.saturdayBool = saturdaySwitch.on
            course.instructorName = instructorNameTextField.text
            course.instructorPhone = instructorPhoneTextField.text
            course.instructorEmail = instructorEmailTextField.text
            course.taName = taNameTextField.text
            course.taEmail = taEmailTextField.text
            
            //store the course
            var e: NSError?
            if managedObjectContext.save(&e) != true {
                println("insert error: \(e!.localizedDescription)")
                return
            }
        }
        
        //create event store and check for permission to asscess calender
        let eventStore = EKEventStore()
        
        switch EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent){
        case .Authorized:
                insertEvent(eventStore)
        case .Denied:
                println("Access Denied")
        case .NotDetermined:
                eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion:{[weak self] (granted: Bool, error: NSError!) -> Void in if granted {
                            self!.insertEvent(eventStore)
                        } else {
                            println("Access denied")
                        }
                })
        default:
            println("Case Default")
        }
        
        //display save confrimation message and perform segue
        let alertController = UIAlertController(title: "Course Saved", message: courseNameTextField.text + " has been saved.", preferredStyle: .Alert)
        let doneAction = UIAlertAction(title: "OK", style: .Default, handler: {
            (action: UIAlertAction!) in
            self.performSegueWithIdentifier("unwindToCourses", sender: self)
        })
        alertController.addAction(doneAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        // Execute the unwind segue and go back to the home screen
        performSegueWithIdentifier("unwindToCourses", sender: self)
        
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
    
    /********************************************************************************
    FUNCTION:		 func insertEvent(store: EKEventStore)
    
    ARGUMENTS:		store: EKEventStore, the store that called the funcation
    
    RETURNS:		this function has no return value
    
    NOTES:			this function create an event for the class and adds it to the calender
    ************************************************************************************/
    func insertEvent(store: EKEventStore) {
        //get all calenders that support events
        let calendars = store.calendarsForEntityType(EKEntityTypeEvent)as! [EKCalendar]
    
        for calendar in calendars {
            
            if calendar.title == "Class_Planner" {
                //locate class planner calender and create event attributes
                let startString = course.startDate + " " + course.startTime
                let endString = course.startDate + " " + course.endTime
                
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM/dd/yy hh:mm a"
                
                let dateStart = dateFormatter.dateFromString(startString)
                let dateEnd = dateFormatter.dateFromString(endString)
                var ekDays:[NSNumber] = []
                let endEvent = [EKRecurrenceEnd.recurrenceEndWithEndDate(dateEnd)]
                
                if course.mondayBool == true{
                    ekDays.append(EKMonday)
                }
                if course.tuesdayBool == true{
                    ekDays.append(EKTuesday)
                }
                if course.wednesdayBool == true{
                    ekDays.append(EKWednesday)
                }
                if course.thursdayBool == true{
                    ekDays.append(EKThursday)
                }
                if course.fridayBool == true{
                    ekDays.append(EKFriday)
                }
                if course.saturdayBool == true{
                    ekDays.append(EKSaturday)
                }
                
                // Create Event
                var event = EKEvent(eventStore: store)
                event.calendar = calendar
            
                event.title = course.courseName
                event.startDate = dateStart
                event.endDate = dateEnd
                let months = [1,2,3,4,5,6,7,8,9,10,11,12]
                let recur = EKRecurrenceRule(recurrenceWithFrequency:EKRecurrenceFrequencyWeekly, interval:0, daysOfTheWeek:[ekDays], daysOfTheMonth:nil, monthsOfTheYear:nil, weeksOfTheYear:nil,daysOfTheYear:nil, setPositions: nil, end: EKRecurrenceEnd.recurrenceEndWithEndDate(dateEnd)! as! EKRecurrenceEnd)
                event.addRecurrenceRule(recur)
            
                // Save Event in Calendar
                var error: NSError?
                let result = store.saveEvent(event, span: EKSpanThisEvent, error: &error)
            
                if result == false {
                    if let theError = error {
                        println("An error occured \(theError)")
                    }
                }
            }
        }
    }

}