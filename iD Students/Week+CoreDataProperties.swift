//
//  Week+CoreDataProperties.swift
//  iD Students
//
//  Created by Voltage on 6/9/15.
//  Copyright © 2015 Gabriel Revells. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Week {

    @NSManaged var classTaught: String?
    @NSManaged var date: NSDate?
    @NSManaged var location: String?
    @NSManaged var weekNumber: NSNumber?
    @NSManaged var roster: NSOrderedSet?

}
