//
//  WeekTableViewController.swift
//  iD Students
//
//  Created by Voltage on 6/8/15.
//  Copyright © 2015 Gabriel Revells. All rights reserved.
//

import UIKit
import CoreData

class WeekTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
	
	var detailViewController: DetailViewController? = nil
	var managedObjectContext: NSManagedObjectContext? = nil
	var move = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
		
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("goToSettings"))
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: Selector("edit"))
		
		if let split = self.splitViewController {
			let controllers = split.viewControllers
			self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
		}
		
		if self.fetchedResultsController.sections![0].numberOfObjects != 0 {
			self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
			tableView.contentOffset = CGPointMake(0, 44)
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewWillAppear(animated: Bool) {
		if self.fetchedResultsController.sections![0].numberOfObjects != 0 && move{
			self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
			tableView.contentOffset = CGPointMake(0, 44)
		} else {
			move = true
		}
		
		super.viewWillAppear(animated)
	}
	
	func edit() {
		if tableView.editing {
			tableView.setEditing(false, animated: true)
			
			self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: Selector("edit"))
			
			self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("goToSettings"))
			
			if self.fetchedResultsController.sections![0].numberOfObjects != 0 {
				//self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
				//tableView.contentOffset = CGPointMake(0, 44)
			}
		} else {
			tableView.setEditing(true, animated: true)
			
			self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("edit"))
			self.navigationItem.leftBarButtonItem = nil
			
			self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
		}
	}
	
	// MARK: - Table view data source
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return self.fetchedResultsController.sections?.count ?? 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let sectionInfo = self.fetchedResultsController.sections![section]
		return sectionInfo.numberOfObjects + 1
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		print("Row: \(indexPath.row)", appendNewline: true)
		
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCellWithIdentifier("addNewWeekCell", forIndexPath: indexPath)
			return cell
		}
		
		let object = self.fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)) as! Week
		
		let cell = tableView.dequeueReusableCellWithIdentifier("weekCell", forIndexPath: indexPath)
		
		let weekNum = object.weekNumber
		
		print(weekNum, appendNewline: true)
		
		cell.textLabel?.text = "Week \(weekNum!)"
		
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
		dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
		
		cell.detailTextLabel?.text = String(dateFormatter.stringFromDate(object.date!))
		
		// Configure the cell...
		
		return cell
	}
	
	// Override to support conditional editing of the table view.
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		if indexPath.row == 0 {
			return false
		}
		return true
	}
	
	// Override to support editing the table view.
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
			// Delete the row from the data source
			self.managedObjectContext?.deleteObject(self.fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)))
			
			do {
				try managedObjectContext!.save()
			} catch {
				let nserror = error as NSError
				NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
				abort()
			}
		}
	}
	
	func controller(controller: NSFetchedResultsController, didChangeObject anObject: NSManagedObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
		switch type {
		case .Insert:
			tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: newIndexPath!.row + 1, inSection: newIndexPath!.section)], withRowAnimation: .Fade)
		case .Delete:
			tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexPath!.row + 1, inSection: indexPath!.section)], withRowAnimation: .Fade)
		case .Update:
			//self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!)
			tableView.cellForRowAtIndexPath(indexPath!)
		case .Move:
			tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
			tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
		}
	}
	
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
		if segue.identifier == "loadWeekRoster" {
			let dest = segue.destinationViewController as! RosterTableViewController
			let indexPath = self.tableView.indexPathForSelectedRow
			
			dest.managedObjectContext = self.managedObjectContext
			dest.currentWeek = self.fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: indexPath!.row - 1, inSection: indexPath!.section)) as? Week
		}
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: false)
	}
	
	func goToSettings() {
		performSegueWithIdentifier("segueToSettingsView", sender: self)
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
		let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
		
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
	
	@IBAction func unwindToWeekView(unwindSegue: UIStoryboardSegue) {}
}
