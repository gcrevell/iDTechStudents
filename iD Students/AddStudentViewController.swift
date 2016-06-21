//
//  AddStudentViewController.swift
//  iD Students
//
//  Created by Voltage on 6/10/15.
//  Copyright © 2015 Gabriel Revells. All rights reserved.
//

import UIKit
import CoreData

class AddStudentViewController: UIViewController, NSFetchedResultsControllerDelegate {
	
	// MARK: Variables
	
	var managedObjectContext: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	
	var newStudentNumber = 0
	var weekToAddTo: Week? = nil

	@IBOutlet weak var alertLevelImageView: UIImageView!
	@IBOutlet weak var alertLevelSegmentedControl: UISegmentedControl!
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var projectTitleTextField: UITextField!
	@IBOutlet weak var notesTextView: UITextView!
	var cancelled = false
	
	// MARK: - View
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		alertLevelImageView.image = alertImage(alertImages(rawValue: alertLevelSegmentedControl.selectedSegmentIndex)!)
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("done"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: Buttons
	
	/// Function called when the done button is pressed.
	/// It checks the input data to ensure correctness
	/// and creates a new Student model in the persistant
	/// store.
	func done () {
		// Done button pressed
		print("Creating new student")
		print("Student number is \(newStudentNumber)")
		
		var regex: NSRegularExpression? = nil
		
		do {
			// Try to create a new redular expression to check the name field.
			try regex = NSRegularExpression(pattern: "^\\w+ \\w{1}$", options: NSRegularExpressionOptions.CaseInsensitive)
		} catch {
			let nserror = error as NSError
			NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
			abort()
		}
		
		if nameTextField.text?.characters.count == 0 {
			// No text entered for student name. Alert the user
			print("Nevermind. No name was entered.")
			
			// Create a new Alert view
			let alert = UIAlertController(title: "No student name", message: "You have not entered a anme for the new student. This object will be deleted.", preferredStyle: UIAlertControllerStyle.Alert)
			
			// Add Delete and Cancel buttons to the alert
			alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: { (action: UIAlertAction!) in
				print("Delete the object")
				self.performSegueWithIdentifier("unwindToRosterView", sender: self)
			}))
			alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction!) in
				print("Cancel.")
			}))
			
			// Display the alert
			presentViewController(alert, animated: true, completion: nil)
			return
		} else if regex!.numberOfMatchesInString(nameTextField.text!, options: NSMatchingOptions.Anchored, range: NSMakeRange(0, nameTextField.text!.characters.count)) != 1 {
			// Student name does not fit correct style
			print("Nevermind. Name does not match first name last initial.")
			
			// Create a new alert
			let alert = UIAlertController(title: "Incorrect student name", message: "The student's name is not formatted correctly. Please use first name, last initial.\n\nEx: Voltage A\n\nThis object will be deleted.", preferredStyle: UIAlertControllerStyle.Alert)
			
			// Add the buttons to the alert
			alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: { (action: UIAlertAction!) in
				print("Delete the object")
				self.performSegueWithIdentifier("unwindToRosterView", sender: self)
			}))
			alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction!) in
					print("Cancel deleteing the new object")
			}))
			
			// Present the alert
			presentViewController(alert, animated: true, completion: nil)
			return
		}
		
		// New Student object
		let newStudent =  NSEntityDescription.insertNewObjectForEntityForName("Student", inManagedObjectContext: managedObjectContext) as! Student
		
		// Set Student values
		newStudent.name = nameTextField.text
		newStudent.alertStatus = alertLevelSegmentedControl.selectedSegmentIndex
		newStudent.projectTitle = projectTitleTextField.text
		newStudent.notes = notesTextView.text
		newStudent.number = newStudentNumber
		newStudent.weekAttended = self.weekToAddTo
		
		// Save the context.
		do {
			try managedObjectContext.save()
		} catch {
			let nserror = error as NSError
			NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
			abort()
		}
		
		self.performSegueWithIdentifier("unwindToRosterView", sender: self)
	}
	
	/// This function is called when the segmented control value is changed.
	/// It sets the image to the correct value based on the selected value.
	///
	///- parameter sender: The segmented selector whose value changed.
	@IBAction func alertLevelChanged(sender: AnyObject) {
		alertLevelImageView.image = alertImage(alertImages(rawValue: alertLevelSegmentedControl.selectedSegmentIndex)!)
	}
	
	// MARK: - Navigation
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "unwindToRosterView" {
			(segue.destinationViewController as! RosterTableViewController)
		}
	}

}
