//
//  EditStudentViewController.swift
//  iD Students
//
//  Created by Voltage on 6/11/15.
//  Copyright © 2015 Gabriel Revells. All rights reserved.
//

import UIKit

class EditStudentViewController: UIViewController {
	
	var detail: Student!
	@IBOutlet weak var alertImageView: UIImageView!
	@IBOutlet weak var alertLevelPicker: UISegmentedControl!
	@IBOutlet weak var projectNameTextField: UITextField!
	@IBOutlet weak var notesTextView: UITextView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		self.alertLevelPicker.selectedSegmentIndex = Int(detail.alertStatus!)
		self.segmentedViewValueChanged(self)
		
		if detail.projectTitle!.startIndex != detail.projectTitle!.endIndex {
			projectNameTextField.text = detail.projectTitle
		}
		
		if detail.notes!.startIndex != detail.notes?.endIndex {
			notesTextView.text = detail.notes
		}
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("done"))
		
		self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func segmentedViewValueChanged(sender: AnyObject) {
		alertImageView.image = alertImage(alertImages(rawValue: alertLevelPicker.selectedSegmentIndex)!)
	}
	
	func done() {
		let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
		
		detail.alertStatus = alertLevelPicker.selectedSegmentIndex
		detail.projectTitle = projectNameTextField.text
		detail.notes = notesTextView.text
		
		do {
			try context.save()
		} catch {
			let nserror = error as NSError
			NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
			abort()
		}
		
		self.performSegueWithIdentifier("unwindToDetailView", sender: self)
	}

}
