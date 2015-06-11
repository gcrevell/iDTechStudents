//
//  DetailViewController.swift
//  iD Students
//
//  Created by Voltage on 6/8/15.
//  Copyright © 2015 Gabriel Revells. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
	
	@IBOutlet weak var alertLevelImage: UIImageView!
	@IBOutlet weak var projectNameLabel: UILabel!
	@IBOutlet weak var notesTextView: UITextView!
	
	var detailItem: Student? {
		didSet {
			// Update the view.
			//self.configureView()
		}
	}
	
	func configureView() {
		// Update the user interface for the detail item.
		if let detail = self.detailItem {
			self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: Selector("edit"))
			self.navigationItem.title = detail.name
			
			alertLevelImage.image = alertImage(alertImages(rawValue: Int(detail.alertStatus!))!)
			
			if detail.projectTitle!.startIndex != detail.projectTitle!.endIndex {
				projectNameLabel.text = detail.projectTitle
			} else {
				projectNameLabel.text = "No Project Title"
			}
			
			if detail.notes!.startIndex != detail.notes?.endIndex {
				notesTextView.text = detail.notes
			} else {
				notesTextView.text = "No notes for this student"
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.configureView()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func edit() {
		performSegueWithIdentifier("segueToEditStudent", sender: self)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "segueToEditStudent" {
			let dest = segue.destinationViewController as! EditStudentViewController
			dest.detail = detailItem
		}
	}
	
	@IBAction func unwindToDetailView(unwindSegue: UIStoryboardSegue) {
		self.configureView()
	}
}

