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


class ClassAssignmentsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    
    @IBOutlet weak var noAssignmentsLabel: UILabel!             //no assignments message
    var courseName:String!                                      //name of class
    
    //array of assignments
    var assignments:[Assignment] = []
    
    //create managedObjectContext and fetechResultController for retriving from CoreData
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
        
        //create Fetech Request, predicate and sortDescriptor
        var fetchRequest = NSFetchRequest(entityName: "Assignment")
        let sortDescriptor = NSSortDescriptor(key: "dueDate", ascending: true)
        let predicate = NSPredicate(format: "courseName == %@", courseName)
        
        // Set the predicate and sortDescriptor on the fetch request
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //assign FetchRequest to FetchRequestController and assign it's delegate
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        
        //retirve assignments from CoreData
        var e: NSError?
        var result = fetchResultController.performFetch(&e)
        assignments = fetchResultController.fetchedObjects as! [Assignment]
        
        if result != true{
            println(e?.localizedDescription)
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

    // MARK: - Table view data source
    /********************************************************************************
    FUNCTION:		func numberOfSectionsInTableView(tableView: UITableView) -> Int
    
    ARGUMENTS:		tableView: UITableView, a table view requesting this information.
    
    RETURNS:		The function returns a NSInteger reperseting the number of sections in the table
    
    NOTES:			This function returns the number of sections in the table, in this case 1
    ************************************************************************************/
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    /********************************************************************************
    FUNCTION:		func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    
    ARGUMENTS:		tableView: UITableView, The table view requesting this information, section: Int, index number identifying a section in
    tableView.
    
    RETURNS:		The function returns a NSInteger repersenting the number of rows in the section
    
    NOTES:			This function gets the number of courses and returns it as the number of rows for the tableview
    ************************************************************************************/
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if there are no assignments
        if assignments.count == 0{
            noAssignmentsLabel.hidden = false
            tableView.backgroundView = noAssignmentsLabel
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            return 0
        //otherwise hide no note message and return the number of assignments
        }else{
            noAssignmentsLabel.hidden = true
            tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            return assignments.count
        }

    }
    
    /********************************************************************************
    FUNCTION:		func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    
    ARGUMENTS:		(UITableView *)tableView, the tableview requesting the cell, (indexPath: NSIndexPath, index path locating a row in
    tableView
    
    
    RETURNS:		The function returns an UITableViewCell that the tableview can use for the specified row
    
    NOTES:			This function gets a cell and sets it up for use in the tableview
    ************************************************************************************/
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("classAssignmentCell", forIndexPath: indexPath) as! ClassAssignmentsTableViewCell
        
        // Configure the cell
        let today = NSDate()
        let assignment = assignments[indexPath.row]
        cell.classAssignmentNameLabel.text = assignment.title
        cell.classAssignmentDueDateLabel.text = assignment.dueDateString
        //if assignment is past due change font color to red
        if assignment.dueDate.compare(today) == .OrderedAscending{
            cell.classAssignmentNameLabel.textColor = UIColor.redColor()
            cell.classAssignmentDueDateLabel.textColor = UIColor.redColor()
            
        }

        return cell
    }
    
    /********************************************************************************
    FUNCTION:		override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    
    ARGUMENTS:		tableView: UITableView, the tableview requesting the cell, indexPath: NSIndexPath, index path locating a row in
    tableView
    
    
    RETURNS:		The function returns a bool stating wheather the row can be edited
    
    NOTES:			This function retruns true when there is an attempted to edit a row
    ************************************************************************************/
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    /********************************************************************************
    FUNCTION:		override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,
    forRowAtIndexPath indexPath: NSIndexPath)
    
    ARGUMENTS:		tableView: UITableView, the tableview requesting the cell, editingStyle: UITableViewCellEditingStyle, the style of editing
    being done indexPath: NSIndexPath, index path locating a row in tableView
    
    RETURNS:		The function has no return value
    
    NOTES:			This function performs the editing requested on a table View
    ************************************************************************************/
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //if the request is a delete
        if editingStyle == .Delete {
            // create fetchRequest, predicate and sortDescriptor for assignments
            var fetchRequest = NSFetchRequest(entityName: "Assignment")
            let sortDescriptor = NSSortDescriptor(key: "dueDate", ascending: true)
            let predicate = NSPredicate(format: "courseName == %@", courseName)
            
            // Set the predicate and sortDescriptor on the fetch request
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            
            
            // Find the assignment object the user is trying to delete
            let assignmentToDelete = assignments[indexPath.row]
                
            // Delete it from the managedObjectContext
            managedObjectContext?.deleteObject(assignmentToDelete)
                
            //assign FetchRequest to FetchRequestController and assign it's delegate
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
                
            //retrive updated courses from coreData
            var e: NSError?
            var result = fetchResultController.performFetch(&e)
            assignments = fetchResultController.fetchedObjects as! [Assignment]
                
            if result != true{
                println(e?.localizedDescription)
            }
            
            // Tell the table view to animate out that row
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            //save changes to CoreData
            save()
        }
    }
    
    // MARK: controllerUpdates
    /********************************************************************************
    FUNCTION:		func controllerWillChangeContent(controller: NSFetchedResultsController!)
    
    ARGUMENTS:		controller: NSFetchedResultsController!, the  NSFetchedResultsController requesting the update
    
    RETURNS:		The function has no return value
    
    NOTES:			This function tells tableView to begin updates
    ************************************************************************************/
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    /********************************************************************************
    FUNCTION:		func controller(controller: NSFetchedResultsController!, didChangeObject anObject: AnyObject!, atIndexPath indexPath:
    NSIndexPath!, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath!)
    
    ARGUMENTS:		controller: NSFetchedResultsController!, the  NSFetchedResultsController requesting the update, anObject: AnyObject!,
    the object that changed,indexPath: NSIndexPath!, the indexpath for the row that changed type: NSFetchedResultsChangeType,
    the type of change being made, newIndexPath: NSIndexPath!, the new indexpath for item being inserted.
    
    RETURNS:		The function has no return value
    
    NOTES:			This function tells tableView how to update the table that was changed
    ************************************************************************************/
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type{
            //insert item
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            //delete item
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            //update item
        case .Update:
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            //default
        default:
            tableView.reloadData()
            
        }
        //refresh the list of assignments
        assignments = controller.fetchedObjects as! [Assignment]
    }
    
    /********************************************************************************
    FUNCTION:		func controllerDidChangeContent(controller: NSFetchedResultsController!)
    
    ARGUMENTS:		controller: NSFetchedResultsController!, the  NSFetchedResultsController requesting the update
    
    RETURNS:		The function has no return value
    
    NOTES:			This function tells tableView to end updates
    ************************************************************************************/
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
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
        //if createAssigbnebt segue
        if segue.identifier == "createAssignment" {
            let destinationController = segue.destinationViewController as! CreateClassAssignmentViewController
            
            // Passing the courseName and createflag to the create view
            destinationController.courseName = courseName
            destinationController.createFlag = true
            
        }
        //if viewAssignment segue
        if segue.identifier == "viewAssignment" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let destinationController = segue.destinationViewController as! ClassAssignmentViewController
                
                // Passing the assignment object to the detail view
                destinationController.assignment = assignments[indexPath.row]
            }
        }
        
        
    }
    
    /********************************************************************************
    FUNCTION:		@IBAction func unwindToClassAssignmentList(segue:UIStoryboardSegue)
    
    ARGUMENTS:		segue: UIStoryboardSegue, the segue containing information about the view controllers involved in the segue,
    
    RETURNS:		The function has no return value
    
    NOTES:			This function is called when a segue "unwindToClassAssignmentList" is performed
    ************************************************************************************/
    @IBAction func unwindToClassAssignmentList(segue:UIStoryboardSegue) {
        
    }
}
