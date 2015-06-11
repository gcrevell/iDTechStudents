//
//  AddWeekViewController.swift
//  iD Students
//
//  Created by Voltage on 6/8/15.
//  Copyright © 2015 Gabriel Revells. All rights reserved.
//

import UIKit
import CoreData

class AddWeekViewController: UIViewController, NSFetchedResultsControllerDelegate {
	
	var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

	@IBOutlet weak var classTaughtTextField: UITextField!
	@IBOutlet weak var locationTextField: UITextField!
	@IBOutlet weak var weekStartDatePicker: UIDatePicker!
	@IBOutlet weak var weekNumberStepper: UIStepper!
	@IBOutlet weak var weekNumberLabel: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("done"))
		
		weekNumberLabel.text = String(Int(weekNumberStepper.value))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func done () {
		print("Adding new Week class", appendNewline: true)
		
		let context = managedObjectContext!
		let newWeek =  NSEntityDescription.insertNewObjectForEntityForName("Week", inManagedObjectContext: context) as! Week
		
		newWeek.location = locationTextField.text
		newWeek.classTaught = classTaughtTextField.text
		newWeek.date = weekStartDatePicker.date
		newWeek.weekNumber = Int(weekNumberStepper.value)
		
		
		// Save the context.
		do {
			try context.save()
		} catch {
			let nserror = error as NSError
			NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
			abort()
		}
		
		performSegueWithIdentifier("unwindToWeekView", sender: self)
	}
	
	var fetchedResultsController: NSFetchedResultsController {
		if _fetchedResultsController != nil {
			return _fetchedResultsController!
		}
		
		let fetchRequest = NSFetchRequest()
		// Edit the entity name as appropriate.
		let entity = NSEntityDescription.entityForName("Week", inManagedObjectContext: self.managedObjectContext!)
		fetchRequest.entity = entity
		
		// Set the batch size to a suitable number.
		fetchRequest.fetchBatchSize = 20
		
		// Edit the sort key as appropriate.
		let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
		
		fetchRequest.sortDescriptors = [sortDescriptor]
		
		// Edit the section name key path and cache name if appropriate.
		// nil for section name key path means "no sections".
		let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
		aFetchedResultsController.delegate = self
		_fetchedResultsController = aFetchedResultsController
		
		do {
			try _fetchedResultsController!.performFetch()
		} catch {
			let nserror = error as NSError
			NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
			abort()
		}
		
		return _fetchedResultsController!
	}
	var _fetchedResultsController: NSFetchedResultsController? = nil

	@IBAction func stepperValueChanged(sender: AnyObject) {
		weekNumberLabel.text = String(Int(weekNumberStepper.value))
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
