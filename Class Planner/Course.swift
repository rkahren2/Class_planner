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
import Foundation
import CoreData


class Course: NSManagedObject {
    @NSManaged var courseID:NSNumber!           //course ID Number
    @NSManaged var courseName:String!           //name of the course
    @NSManaged var startDate:String!            //date the course starts
    @NSManaged var endDate:String!              //date the course ends
    @NSManaged var startTime:String!            //time the course starts
    @NSManaged var endTime:String!              //time the course ends
    @NSManaged var mondayBool:NSNumber!         //bool indicating if the class meets on Mondays
    @NSManaged var tuesdayBool:NSNumber!        //bool indicating if the class meets on Tuesdays
    @NSManaged var wednesdayBool:NSNumber!      //bool indicating if the class meets on Wednesdays
    @NSManaged var thursdayBool:NSNumber!       //bool indicating if the class meets on Thursdays
    @NSManaged var fridayBool:NSNumber!         //bool indicating if the class meets on Fridays
    @NSManaged var saturdayBool:NSNumber!       //bool indicating if the class meets on Staurdays
    @NSManaged var instructorName:String!       //name of instructor
    @NSManaged var instructorPhone:String!      //instructor phone number
    @NSManaged var instructorEmail:String!      //instructor email
    @NSManaged var taName:String!               //TA's name
    @NSManaged var taEmail:String!              //TA's email
    
    
    
    
}