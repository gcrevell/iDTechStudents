//
//  SettingsTableViewController.swift
//  iD Students
//
//  Created by Voltage on 6/12/15.
//  Copyright © 2015 Gabriel Revells. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UIAlertViewDelegate {
	
	let defaults = NSUserDefaults()
	var alertNum = 1
	var newPassword: String!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false
		
		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - Table view data source
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return 1
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		
		if indexPath.row == 0 && indexPath.section == 0 {
			showFirstAlert()
		}
	}
	
	func showFirstAlert() {
		alertNum = 1
		let alert = UIAlertView(title: "Enter your old PIN", message: nil, delegate: self, cancelButtonTitle: "Enter")
		alert.alertViewStyle = UIAlertViewStyle.SecureTextInput
		alert.textFieldAtIndex(0)?.keyboardType = UIKeyboardType.NumberPad
		alert.show()
	}
	
	func showSecondAlert() {
		alertNum = 2
		let alert = UIAlertView(title: "Enter your new PIN", message: nil, delegate: self, cancelButtonTitle: "Enter")
		alert.alertViewStyle = UIAlertViewStyle.SecureTextInput
		alert.textFieldAtIndex(0)?.keyboardType = UIKeyboardType.NumberPad
		alert.show()
	}
	
	func showThirdAlert() {
		alertNum = 3
		let alert = UIAlertView(title: "Re-enter your new PIN", message: nil, delegate: self, cancelButtonTitle: "Enter")
		alert.alertViewStyle = UIAlertViewStyle.SecureTextInput
		alert.textFieldAtIndex(0)?.keyboardType = UIKeyboardType.NumberPad
		alert.show()
	}
	
	func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
		if alertNum == 1 {
			if alertView.textFieldAtIndex(0)!.text! == defaults.valueForKey("PASSWORD") as! String {
				showSecondAlert()
			} else {
				let alert = UIAlertController(title: "Incorrect password entered", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
				alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
				presentViewController(alert, animated: true, completion: nil)
			}
			return
		}
		
		if alertNum == 2 {
			newPassword = alertView.textFieldAtIndex(0)!.text
			showThirdAlert()
			return
		}
		
		if alertNum == 3 {
			if alertView.textFieldAtIndex(0)!.text == newPassword {
				defaults.setObject(newPassword, forKey: "PASSWORD")
				defaults.synchronize()
				
				let alert = UIAlertController(title: "Your password has been updated", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
				alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
				presentViewController(alert, animated: true, completion: nil)
			} else {
				let alert = UIAlertController(title: "Could not update password", message: "Your password did not match and therefore could not be updated.", preferredStyle: UIAlertControllerStyle.Alert)
				alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
				presentViewController(alert, animated: true, completion: nil)
			}
			return
		}
	}
	
	/*
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
	let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
	
	// Configure the cell...
	
	return cell
	}
	*/
	
	/*
	// Override to support conditional editing of the table view.
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
	// Return false if you do not want the specified item to be editable.
	return true
	}
	*/
	
	/*
	// Override to support editing the table view.
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
	if editingStyle == .Delete {
	// Delete the row from the data source
	tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
	} else if editingStyle == .Insert {
	// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
	}
	}
	*/
	
	/*
	// Override to support rearranging the table view.
	override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
	
	}
	*/
	
	/*
	// Override to support conditional rearranging of the table view.
	override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
	// Return NO if you do not want the item to be re-orderable.
	return true
	}
	*/
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
}
