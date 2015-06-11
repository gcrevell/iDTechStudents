//
//  Student+CoreDataProperties.swift
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

extension Student {

    @NSManaged var alertStatus: NSNumber?
    @NSManaged var name: String?
    @NSManaged var notes: String?
    @NSManaged var number: NSNumber?
    @NSManaged var projectTitle: String?
    @NSManaged var weekAttended: Week?

}
