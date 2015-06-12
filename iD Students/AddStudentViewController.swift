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
	
	var managedObjectContext: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	
	var newStudentNumber = 0
	var weekToAddTo: Week? = nil

	@IBOutlet weak var alertLevelImageView: UIImageView!
	@IBOutlet weak var alertLevelSegmentedControl: UISegmentedControl!
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var projectTitleTextField: UITextField!
	@IBOutlet weak var notesTextView: UITextView!
	
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
	
	func done () {
		print("Creating new student", appendNewline: true)
		print("Student number is \(newStudentNumber)", appendNewline: true)
		
		var regex: NSRegularExpression? = nil
		
		do {
			try regex = NSRegularExpression(pattern: "^\\w+ \\w{1}$", options: NSRegularExpressionOptions.CaseInsensitive)
		} catch {
			let nserror = error as NSError
			NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
			abort()
		}
		
		if nameTextField.text?.characters.count == 0 {
			//No text entered for student name. Alert the user
			print("Nevermind...", appendNewline: true)
			
			let alert = UIAlertController(title: "No student name", message: "You have not entered a anme for the new student. This object will be deleted.", preferredStyle: UIAlertControllerStyle.Alert)
			
			alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: { (action: UIAlertAction!) in
				self.performSegueWithIdentifier("unwindToRosterView", sender: self)
			}))
			alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
			
			presentViewController(alert, animated: true, completion: nil)
			return
		} else if regex!.numberOfMatchesInString(nameTextField.text!, options: NSMatchingOptions.Anchored, range: NSMakeRange(0, nameTextField.text!.characters.count)) != 1 {
			//Student name does not fit correct style
			print("Nevermind...", appendNewline: true)
			
			let alert = UIAlertController(title: "Incorrect student name", message: "The student's name is not formatted correctly. Please use first name, last initial.\n\nEx: Voltage A\n\nThis object will be deleted.", preferredStyle: UIAlertControllerStyle.Alert)
			
			alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: { (action: UIAlertAction!) in
				self.performSegueWithIdentifier("unwindToRosterView", sender: self)
			}))
			alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
			
			presentViewController(alert, animated: true, completion: nil)
			return
		}
		
		let newStudent =  NSEntityDescription.insertNewObjectForEntityForName("Student", inManagedObjectContext: managedObjectContext) as! Student
		
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
    
	@IBAction func alertLevelChanged(sender: AnyObject) {
		alertLevelImageView.image = alertImage(alertImages(rawValue: alertLevelSegmentedControl.selectedSegmentIndex)!)
	}

}
