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

class TodayAssignmentsTableViewCell: UITableViewCell {

    @IBOutlet weak var assignmentNameLabel: UILabel!        //display name of assignment
    @IBOutlet weak var courseNameLabel: UILabel!            //display name of class
    @IBOutlet weak var dueDateLabel: UILabel!               //display due date
    
    /********************************************************************************
    FUNCTION:		override func awakeFromNib()
    
    ARGUMENTS:		This function recieves no arguments
    
    RETURNS:		The function has no return value
    
    NOTES:			The function sends an awakeFromNib message to each object recreated from a nib archive
    *******************************************************************************/
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /********************************************************************************
    FUNCTION:		override func setSelected(selected: Bool, animated: Bool)
    
    ARGUMENTS:		selected: Bool, Bool stating if it show be selected,animated: Bool, Bool
    stating if it should be animated
    
    RETURNS:		The function has no return value
    
    NOTES:			The function sets the state of the cell and optionally animates the
    transistion between states
    *******************************************************************************/
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
