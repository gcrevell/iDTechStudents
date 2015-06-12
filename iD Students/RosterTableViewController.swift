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
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "edit")
		self.navigationItem.title = "Week \(currentWeek!.weekNumber!) Roster"
		
		if let split = self.splitViewController {
			let controllers = split.viewControllers
			self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
		}
		
		if let m = maxNumber() {
			maxStudentNumber = m
		}
		
		if self.fetchedResultsController.sections![0].numberOfObjects != 0 {
			self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
			tableView.contentOffset = CGPointMake(0, 44 * 3)
		}
	}
	
	func edit() {
		if tableView.editing {
			tableView.setEditing(false, animated: true)
			
			self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: Selector("edit"))
			
			if self.fetchedResultsController.sections![0].numberOfObjects != 0 {
				self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
				//tableView.contentOffset = CGPointMake(0, 44 * 3)
			}
		} else {
			tableView.setEditing(true, animated: true)
			
			self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("edit"))
			
			self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
			//tableView.contentOffset = CGPointMake(0, 0)
		}
	}
	
	override func viewWillAppear(animated: Bool) {
		if self.fetchedResultsController.sections![0].numberOfObjects != 0 {
			self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
			tableView.contentOffset = CGPointMake(0, 44 * 3)
		}
		
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
				let object = self.fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: indexPath.row - 3, inSection: indexPath.section)) as! Student
				let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
				controller.detailItem = object
				controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
				controller.navigationItem.leftItemsSupplementBackButton = true
			}
		} else if segue.identifier == "addNewStudentSegue" {
			let controller = segue.destinationViewController as! AddStudentViewController
			
			controller.newStudentNumber = maxStudentNumber++
			controller.weekToAddTo = currentWeek
		} else {
			print(segue.identifier, appendNewline: true)
		}
	}
	
	// MARK: - Table View
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return self.fetchedResultsController.sections?.count ?? 0
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let sectionInfo = self.fetchedResultsController.sections![section]
		return sectionInfo.numberOfObjects + 3
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCellWithIdentifier("addNewStudentCell", forIndexPath: indexPath)
			return cell
		}
		
		if indexPath.row == 1 {
			let cell = tableView.dequeueReusableCellWithIdentifier("basicCell", forIndexPath: indexPath)
			
			let dateFormatter = NSDateFormatter()
			dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
			dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
			cell.textLabel?.text = "Week of \(dateFormatter.stringFromDate(currentWeek!.date!))"
			
			return cell
		}
		
		if indexPath.row == 2 {
			let cell = tableView.dequeueReusableCellWithIdentifier("basicCell", forIndexPath: indexPath)
			
			cell.textLabel?.text = "Taught \(currentWeek!.classTaught!) @ \(currentWeek!.location!)"
			
			return cell
		}
		
		let cell = tableView.dequeueReusableCellWithIdentifier("studentCell", forIndexPath: indexPath) as! StudentTableViewCell
		let student = self.fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: indexPath.row - 3, inSection: indexPath.section)) as! Student
		
		cell.alertImage.image = alertImage(alertImages(rawValue: Int(student.alertStatus!))!)
		cell.nameLabel.text = student.name
		
		print("Student \(student.name!) is number \(student.number!)", appendNewline: true)
		
		return cell
	}
	
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 {
			return false
		}
		
		return true
	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
			self.managedObjectContext?.deleteObject(self.fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: indexPath.row - 3, inSection: indexPath.section)))
			
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
		
		let predicate = NSPredicate(format: "(weekAttended = %@)", currentWeek!)
		
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
			tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: newIndexPath!.row + 3, inSection: newIndexPath!.section)], withRowAnimation: .Fade)
		case .Delete:
			tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexPath!.row + 3, inSection: indexPath!.section)], withRowAnimation: .Fade)
			
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
			let stu = self.fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: fromIndexPath.row - 3, inSection: fromIndexPath.section)) as! Student
			var oldNum = stu.number!
			
			for i in (fromIndexPath.row - 2)..<(toIndexPath.row - 2) {
				let path = NSIndexPath(forRow: i, inSection: fromIndexPath.section)
				let student = self.fetchedResultsController.objectAtIndexPath(path) as! Student
				let temp = student.number!
				student.number = oldNum
				oldNum = temp
			}
			
			stu.number = oldNum
		} else {
			let stu = self.fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: fromIndexPath.row - 3, inSection: fromIndexPath.section)) as! Student
			var oldNum = stu.number!
			
			for var i = fromIndexPath.row - 3; i >= toIndexPath.row - 3; i-- {
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
		if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 {
			return false
		}
		
		return true
	}
	
	override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
		if proposedDestinationIndexPath.row == 0 || proposedDestinationIndexPath.row == 1 || proposedDestinationIndexPath.row == 2 {
			return NSIndexPath(forRow: 3, inSection: 0)
		}
		
		return proposedDestinationIndexPath
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

