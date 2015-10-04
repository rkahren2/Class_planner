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

class TodayViewController: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var classTableView: UITableView!             //tableview for displaying classes
    @IBOutlet weak var assignmentTableView: UITableView!        //tableview for displaying assignments
    @IBOutlet weak var noAssignmentsLabel: UILabel!             //no assignments message
    @IBOutlet weak var noClassLabel: UILabel!                   //np classes message

    //arrays for objects fetched from core data
    var courses:[Course] = []
    var assignments:[Assignment] = []
    
    //used to fetch objects from core data
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var fetchResultController:NSFetchedResultsController!
    var predicate:NSPredicate!

    /********************************************************************************
    FUNCTION:		override func viewWillAppear(animated: Bool)
    
    ARGUMENTS:		animated: Bool, bool to indicate if it should be animated
    
    RETURNS:		The function has no return value
    
    NOTES:			This function is called when the view is about to appear on screen
    ************************************************************************************/
    override func viewWillAppear(animated: Bool) {
        //retire data for tables
        configureCoursesTable()
        configureAssignmentTabel()
        //reload tables
        classTableView.reloadData()
        assignmentTableView.reloadData()
    }
    
    /********************************************************************************
    FUNCTION:		 override func viewDidLoad()
    
    ARGUMENTS:		This function recieves no arguments
    
    RETURNS:		The function has no return value
    
    NOTES:			The function is called after the controller’s view is loaded into memory. It poplates the UI elements of the view,
                    and sets the navigation bar colors
    ************************************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //set navigational bar colors
        var nav = self.navigationController?.navigationBar
        nav?.barTintColor = UIColor.blueColor()
        nav?.tintColor = UIColor.whiteColor()
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        UITabBar.appearance().barTintColor = UIColor.blueColor()
        
        //format date for title
        let today = NSDate()
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        
        //set title
        self.navigationItem.title = dateFormatter.stringFromDate(today)
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
    // MARK: - Table view data source
    /********************************************************************************
    FUNCTION:		func numberOfSectionsInTableView(tableView: UITableView) -> Int
    
    ARGUMENTS:		tableView: UITableView, a table view requesting this information.
    
    RETURNS:		The function returns a NSInteger reperseting the number of sections in the table
    
    NOTES:			This function returns the number of sections in the table, in this case 1
    ************************************************************************************/
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
            }
    /********************************************************************************
    FUNCTION:		func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    
    ARGUMENTS:		tableView: UITableView, The table view requesting this information, section: Int, index number identifying a section in 
                    tableView.
    
    RETURNS:		The function returns a NSInteger repersenting the number of rows in the section
    
    NOTES:			This function gets the number of courses or assignements and returns it as the number of 
                    rows for the tableview
    ************************************************************************************/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if caller is classTableView
        if tableView .isEqual(classTableView){
            //if there are no courses
            if courses.count == 0{
                //display no class message and return 0
                noClassLabel.hidden = false
                classTableView.backgroundView = noClassLabel
                classTableView.separatorStyle = UITableViewCellSeparatorStyle.None
                return 0
            //otherwise hide no class message and return course.count
            }else{
                noClassLabel.hidden = true
                classTableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                return courses.count
            }
        }
        //if caller is assignmentTableView
        if tableView .isEqual(assignmentTableView){
            //if there are no assignments
            if assignments.count == 0{
                //display no assignment message and return 0
                noAssignmentsLabel.hidden = false
                assignmentTableView.backgroundView = noAssignmentsLabel
                assignmentTableView.separatorStyle = UITableViewCellSeparatorStyle.None
                return 0
            //otherwise hide no assginment message and return assignment count
            }else{
                noAssignmentsLabel.hidden = true
                assignmentTableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                return assignments.count
            }
        }
        //return 0 for all other tables
        return 0
    }
    /********************************************************************************
    FUNCTION:		func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    
    ARGUMENTS:		(UITableView *)tableView, the tableview requesting the cell, (indexPath: NSIndexPath, index path locating a row in 
                    tableView
    
    
    RETURNS:		The function returns an UITableViewCell that the tableview can use for the specified row
    
    NOTES:			This function gets a cell and sets it up for use in the tableview
    ************************************************************************************/
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //if caller is classTableView
        if tableView .isEqual(classTableView){
            let cell = tableView.dequeueReusableCellWithIdentifier("courseCell", forIndexPath: indexPath) as! TodayCourseTableViewCell
        
            // Configure the cell
            let course = courses[indexPath.row]
            cell.courseNameLabel.text = course.courseName
            cell.timeLabel.text = course.startTime
        
            return cell
        }
        //if caller is assignmentTableView
        if tableView .isEqual(assignmentTableView){
            let cell = tableView.dequeueReusableCellWithIdentifier("assignmentsCell", forIndexPath: indexPath) as! TodayAssignmentsTableViewCell
            //configure the cell
            let today = NSDate()
            let assignment = assignments[indexPath.row]
            cell.assignmentNameLabel.text = assignment.title
            cell.courseNameLabel.text = assignment.courseName
            cell.dueDateLabel.text = assignment.dueDateString
            //if assignment is past due change color to red
            if assignment.dueDate.compare(today) == .OrderedAscending{
                cell.assignmentNameLabel.textColor = UIColor.redColor()
                cell.dueDateLabel.textColor = UIColor.redColor()
                cell.courseNameLabel.textColor = UIColor.redColor()
            }
            
            return cell
            
        }
        //all other tables
        let cell = tableView.dequeueReusableCellWithIdentifier("noTable", forIndexPath: indexPath) as! TodayCourseTableViewCell
        return cell
    }

    
    /********************************************************************************
    FUNCTION:		func getDayOfWeek()->Int
    
    ARGUMENTS:		This function recieves no arguments
    
    RETURNS:		The function returns an interger that repests the current day of the week
    
    NOTES:          This function get the current date and returns an interger from 1 to 7 
                    repersenting the current day of the week.
    ************************************************************************************/
    func getDayOfWeek()->Int {
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.WeekdayCalendarUnit, fromDate: date)
        let day = components.weekday
        
        return day
    }
    /********************************************************************************
    FUNCTION:		func configureCoursesTable()
    
    ARGUMENTS:		This function recieves no arguments
    
    RETURNS:		The function has no return value
    
    NOTES:          This function retrives from coredata the data for the coursesTableView
    ************************************************************************************/
    func configureCoursesTable(){
        //create NSFetchRequest and sortDescriptor
        var fetchRequest = NSFetchRequest(entityName: "Course")
        let sortDescriptor = NSSortDescriptor(key: "courseName", ascending: true)
        //create predicate
        let testBool = true
        let weekday = getDayOfWeek()
        if weekday == 2{
            predicate = NSPredicate(format: "mondayBool == %@", testBool)
        }
        if weekday == 3{
            predicate = NSPredicate(format: "tuesdayBool == %@", testBool)
        }
        if weekday == 4{
            predicate = NSPredicate(format: "wednesdayBool == %@", testBool)
        }
        if weekday == 5{
            predicate = NSPredicate(format: "thursdayBool == %@", testBool)
        }
        if weekday == 6{
            predicate = NSPredicate(format: "fridayBool == %@", testBool)
        }
        if weekday == 7{
            predicate = NSPredicate(format: "saturdayBool == %@", testBool)
        }
        //if not Sunday
        if weekday != 1{
            //assign predicate and sortdescriptors
            fetchRequest.predicate = predicate
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
        }

        
    }
    /********************************************************************************
    FUNCTION:		configureAssignmentTabel()
    
    ARGUMENTS:		This function recieves no arguments
    
    RETURNS:		The function has no return value
    
    NOTES:          This function retrives from coredata the data for the assignmentsTableView
    ************************************************************************************/
    func configureAssignmentTabel(){
        //create NSFetchRequest and sortDescriptor
        var fetchRequest = NSFetchRequest(entityName: "Assignment")
        let sortDescriptor = NSSortDescriptor(key: "dueDate", ascending: true)
        
        // adding $additionalDays
        var components = NSDateComponents()
        components.day = 7
            
        // important: NSCalendarOptions(0)
        let futureDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: NSDate(), options: NSCalendarOptions(0))
        //create predicate
        let predicate = NSPredicate(format: "dueDate < %@", futureDate!)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        //assign FetchRequest to FetchRequestController and assign it's delegate
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        //retirve courses from CoreData
        var e: NSError?
        var result = fetchResultController.performFetch(&e)
        assignments = fetchResultController.fetchedObjects as! [Assignment]
        
        if result != true{
            println(e?.localizedDescription)
        }

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
        //if it is viewClass Segue
        if segue.identifier == "viewClass" {
            if let indexPath = self.classTableView.indexPathForSelectedRow() {
                let destinationController = segue.destinationViewController as! ClassDetailViewController
                
                // Passing the course object to the detail view
                destinationController.course = courses[indexPath.row]
                
            }
        }
        //if it is viewAssignment seue
        if segue.identifier == "viewAssignment" {
            if let indexPath = self.assignmentTableView.indexPathForSelectedRow() {
                let destinationController = segue.destinationViewController as! ClassAssignmentViewController
                
                // Passing the assignment object to the detail view
                destinationController.assignment = assignments[indexPath.row]
                
            }

        }
    }

    

}

