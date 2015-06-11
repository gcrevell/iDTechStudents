//
//  MasterViewController.swift
//  iD Students
//
//  Created by Voltage on 6/8/15.
//  Copyright © 2015 Gabriel Revells. All rights reserved.
//

import UIKit
import CoreData

class RosterTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
	
	var detailViewController: DetailViewController? = nil
	var managedObjectContext: NSManagedObjectContext? = nil
	var maxStudentNumber = 1
	var currentWeek: Week? = nil
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		//self.navigationItem.leftBarButtonItem = self.editButtonItem()
		
		//let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
		//self.navigationItem.rightBarButtonItem = addButton
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "edit")
		
		if let split = self.splitViewController {
			let controllers = split.viewControllers
			self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
		}
		
		if let m = maxNumber() {
			maxStudentNumber = m
		}
	}
	
	func edit() {
		if tableView.editing {
			tableView.setEditing(false, animated: true)
			
			self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: Selector("edit"))
		} else {
			tableView.setEditing(true, animated: true)
			
			self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("edit"))
		}
	}
	
	override func viewWillAppear(animated: Bool) {
		self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
		super.viewWillAppear(animated)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func insertNewObject(sender: AnyObject) {
		let context = self.fetchedResultsController.managedObjectContext
		let entity = self.fetchedResultsController.fetchRequest.entity!
		let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context)
		
		// If appropriate, configure the new managed object.
		// Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
		newManagedObject.setValue(NSDate(), forKey: "timeStamp")
		
		// Save the context.
		do {
			try context.save()
		} catch {
			let nserror = error as NSError
			NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
			abort()
		}
	}
	
	// MARK: - Segues
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showDetail" {
			if let indexPath = self.tableView.indexPathForSelectedRow {
				let object = self.fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)) as! Student
				let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
				controller.detailItem = object
				controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
				controller.navigationItem.leftItemsSupplementBackButton = true
				
			}
		} else if segue.identifier == "addNewStudentSegue" {
			let controller = segue.destinationViewController as! AddStudentViewController
			
			controller.newStudentNumber = maxStudentNumber++
			controller.weekAttended = currentWeek
		}
	}
	
	// MARK: - Table View
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return self.fetchedResultsController.sections?.count ?? 0
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let sectionInfo = self.fetchedResultsController.sections![section]
		return sectionInfo.numberOfObjects + 1
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCellWithIdentifier("addNewStudentCell", forIndexPath: indexPath)
			return cell
		}
		let cell = tableView.dequeueReusableCellWithIdentifier("studentCell", forIndexPath: indexPath) as! StudentTableViewCell
		let student = self.fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)) as! Student
		
		cell.alertImage.image = alertImage(alertImages(rawValue: Int(student.alertStatus!))!)
		cell.nameLabel.text = student.name
		
		print("Student \(student.name!) is number \(student.number!)", appendNewline: true)
		
		return cell
	}
	
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		if indexPath.row == 0 {
			return false
		}
		
		return true
	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
			self.managedObjectContext?.deleteObject(self.fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)))
			
			do {
				try managedObjectContext?.save()
			} catch {
				let nserror = error as NSError
				NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
				abort()
			}
		}
	}
	
	// MARK: - Fetched results controller
	
	var fetchedResultsController: NSFetchedResultsController {
		if _fetchedResultsController != nil {
			return _fetchedResultsController!
		}
		
		let fetchRequest = NSFetchRequest()
		// Edit the entity name as appropriate.
		let entity = NSEntityDescription.entityForName("Student", inManagedObjectContext: self.managedObjectContext!)
		fetchRequest.entity = entity
		
		// Set the batch size to a suitable number.
		fetchRequest.fetchBatchSize = 20
		
		// Edit the sort key as appropriate.
		let sortDescriptor = NSSortDescriptor(key: "number", ascending: true)
		
		fetchRequest.sortDescriptors = [sortDescriptor]
		
		let predicate = NSPredicate(format: "weekAttended = %@", currentWeek!)
		
		fetchRequest.predicate = predicate
		
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
	
	func controllerWillChangeContent(controller: NSFetchedResultsController) {
		self.tableView.beginUpdates()
	}
	
	func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
		switch type {
		case .Insert:
			self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
		case .Delete:
			self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
		default:
			return
		}
	}
	
	func controller(controller: NSFetchedResultsController, didChangeObject anObject: NSManagedObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
		switch type {
		case .Insert:
			tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: newIndexPath!.row + 1, inSection: newIndexPath!.section)], withRowAnimation: .Fade)
		case .Delete:
			tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexPath!.row + 1, inSection: indexPath!.section)], withRowAnimation: .Fade)
			
			for i in (indexPath!.row)..<(maxStudentNumber - 2) {
				let path = NSIndexPath(forRow: i, inSection: indexPath!.section)
				let student = self.fetchedResultsController.objectAtIndexPath(path) as! Student
				student.number = Int(student.number!) - 1
			}
			
			if let m = maxNumber() {
				maxStudentNumber = m
			} else {
				maxStudentNumber = 1
			}
			
		case .Update:
			tableView.reloadData()
			
		case .Move:
			print("Moving", appendNewline: true)
		}
	}
	
	func controllerDidChangeContent(controller: NSFetchedResultsController) {
		self.tableView.endUpdates()
		//self.tableView.reloadData()
	}
	
	@IBAction func unwindToRosterView(unwindSegue: UIStoryboardSegue) {}
	
	// Override to support rearranging the table view.
	override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
		print("Moving", appendNewline: true)
		
		if fromIndexPath.row < toIndexPath.row {
			let stu = self.fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: fromIndexPath.row - 1, inSection: fromIndexPath.section)) as! Student
			var oldNum = stu.number!
			
			for i in (fromIndexPath.row)..<(toIndexPath.row) {
				let path = NSIndexPath(forRow: i, inSection: fromIndexPath.section)
				let student = self.fetchedResultsController.objectAtIndexPath(path) as! Student
				let temp = student.number!
				student.number = oldNum
				oldNum = temp
			}
			
			stu.number = oldNum
		} else {
			let stu = self.fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: fromIndexPath.row - 1, inSection: fromIndexPath.section)) as! Student
			var oldNum = stu.number!
			
			for var i = fromIndexPath.row - 1; i >= toIndexPath.row - 1; i-- {
				let path = NSIndexPath(forRow: i, inSection: fromIndexPath.section)
				let student = self.fetchedResultsController.objectAtIndexPath(path) as! Student
				let temp = student.number!
				print("Setting \(student.name)'s number to \(oldNum).", appendNewline: true)
				student.number = oldNum
				oldNum = temp
			}
			
			stu.number = oldNum
		}
		
		do {
			try managedObjectContext?.save()
		} catch {
			let nserror = error as NSError
			NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
			abort()
		}
	}
	
	// Override to support conditional rearranging of the table view.
	override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		// Return NO if you do not want the item to be re-orderable.
		if indexPath.row == 0 {
			return false
		}
		
		return true
	}
	
	func maxNumber() -> Int? {
		let fetchRequest = NSFetchRequest()
		
		fetchRequest.entity = NSEntityDescription.entityForName("Student", inManagedObjectContext: managedObjectContext!)
		
		fetchRequest.fetchBatchSize = 1
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "number", ascending: false)]
		
		let fetch = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
		
		do {
			try fetch.performFetch()
		} catch {
			let nserror = error as NSError
			NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
			abort()
		}
		if fetch.sections?.count > 0 && fetch.sections![0].numberOfObjects > 0 {
			let student = fetch.objectAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! Student
			return Int(student.number!) + 1
		}
		
		return nil
	}
	
}

