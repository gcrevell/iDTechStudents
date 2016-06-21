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
	
	// MARK: Variables
	
	var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	@IBOutlet weak var classTaughtTextField: UITextField!
	@IBOutlet weak var locationTextField: UITextField!
	@IBOutlet weak var weekStartDatePicker: UIDatePicker!
	@IBOutlet weak var weekNumberStepper: UIStepper!
	@IBOutlet weak var weekNumberLabel: UILabel!
	
	// MARK: View
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		// Add done button
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("done"))
		
		// Set the label to the current week number
		weekNumberLabel.text = String(Int(weekNumberStepper.value))
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: Buttons
	
	/// Function called when the Done button is pressed. It checks
	/// the data for consistancy and presents errors to the user.
	/// It then creates a new Week instance and sets all the values
	/// to the entered value.
	func done () {
		print("Adding new Week class")
		
		if classTaughtTextField.text?.characters.count == 0 {
			// No text entered for class taught. Alert the user
			print("Nevermind. No class taught entered.")
			
			// Creating an alert
			let alert = UIAlertController(title: "No class taught", message: "You have not entered a class taught for this week. This object will be deleted.", preferredStyle: UIAlertControllerStyle.Alert)
			
			// Adding buttons to the alert
			alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: { (action: UIAlertAction!) in
				print("Deleting this object.")
				self.performSegueWithIdentifier("unwindToWeekView", sender: self)
			}))
			alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction!) in
				print("Canceling.")
			}))
			
			// Display the alert
			presentViewController(alert, animated: true, completion: nil)
			return
		} else if locationTextField.text?.characters.count == 0 {
			// No text entered for location
			print("Nevermind. No location entered")
			
			// Create an alert
			let alert = UIAlertController(title: "No location", message: "You have not entered a location taught for this week. This object will be deleted.", preferredStyle: UIAlertControllerStyle.Alert)
			
			// Add buttons
			alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: { (action: UIAlertAction!) in
				print("Deleting this object.")
				self.performSegueWithIdentifier("unwindToWeekView", sender: self)
			}))
			alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action:UIAlertAction!) in
				print("Canceling.")
			}))
			
			// Display
			presentViewController(alert, animated: true, completion: nil)
			return
		} else {
			// Everything checks out
			// Create new Week object
			let newWeek = NSEntityDescription.insertNewObjectForEntityForName("Week", inManagedObjectContext: managedObjectContext!) as! Week
			
			// Set values to the given information
			newWeek.location = locationTextField.text
			newWeek.classTaught = classTaughtTextField.text
			newWeek.date = weekStartDatePicker.date
			newWeek.weekNumber = Int(weekNumberStepper.value)
			
			// Save the context.
			do {
				try managedObjectContext!.save()
			} catch {
				// Unable to save
				let nserror = error as NSError
				NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
				abort()
			}
			
			// Segue
			performSegueWithIdentifier("unwindToWeekView", sender: self)
		}
	}
	
	/// Function called when the week stepper value is changed.
	///
	///- parameter sender: The stepper that changed.
	@IBAction func stepperValueChanged(sender: AnyObject) {
		weekNumberLabel.text = String(Int(weekNumberStepper.value))
	}
	
	// MARK: Core Data
	
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
		let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
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
	
}
