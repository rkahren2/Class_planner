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

class ReturnSegue: UIStoryboardSegue {
    
    
    /********************************************************************************
    FUNCTION:		override func perform
    
    ARGUMENTS:		This function recieves no arguments
    
    RETURNS:		The function has no return value
    
    NOTES:			The function is called when a return segue from the modal view is performed.
                    It dismisses the view
    ************************************************************************************/
    override func perform() {
        // Assign the source and destination views to local variables.
        var secondVCView = self.sourceViewController.view as UIView!
        var firstVCView = self.destinationViewController.view as UIView!
        
        //setup the view window
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        let window = UIApplication.sharedApplication().keyWindow
        window?.insertSubview(firstVCView, aboveSubview: secondVCView)
        
        
        // Animate the transition.
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            firstVCView.frame = CGRectOffset(firstVCView.frame, 0.0, screenHeight)
            secondVCView.frame = CGRectOffset(secondVCView.frame, 0.0, screenHeight)
            
            }) { (Finished) -> Void in
                
                self.sourceViewController.dismissViewControllerAnimated(false, completion: nil)
        }
    }
   
}
