//
//  Assignment.swift
//  Class Planner
//
//  Created by Rob on 4/15/15.
//  Copyright (c) 2015 CSCI 428/628. All rights reserved.
//

import Foundation
import CoreData


class Assignment: NSManagedObject {
    
    @NSManaged var courseName:String!       //course name
    @NSManaged var title:String!            //assignment title
    @NSManaged var details:String!          //assignment details
    @NSManaged var dueDateString:String!    //due date as string
    @NSManaged var dueDate:NSDate!          //due date as nsdate
    
    
}
