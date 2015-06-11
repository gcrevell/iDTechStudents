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
	
	var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	
	var newStudentNumber = 0
	var weekAttended: Week? = nil

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
		print("done pressed", appendNewline: true)
		print("Student number is \(newStudentNumber)", appendNewline: true)
		
		let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
		let newStudent =  NSEntityDescription.insertNewObjectForEntityForName("Student", inManagedObjectContext: context) as! Student
		
		newStudent.name = nameTextField.text
		newStudent.alertStatus = alertLevelSegmentedControl.selectedSegmentIndex
		newStudent.projectTitle = projectTitleTextField.text
		newStudent.notes = notesTextView.text
		newStudent.number = newStudentNumber
		newStudent.weekAttended = self.weekAttended
		
		// Save the context.
		do {
			try context.save()
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
	
	func alertImage(imageType: alertImages) -> UIImage {
		switch imageType {
		case .green :
			return UIImage(named: "GreenAlert.png")!
			
		case .blue :
			return UIImage(named: "BuleQuestion.png")!
			
		case .yellow :
			return UIImage(named: "YellowAlert.png")!
			
		case .red :
			return UIImage(named: "Alert.png")!
		}
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
