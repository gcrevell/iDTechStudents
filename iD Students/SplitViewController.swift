//
//  SplitViewController.swift
//  iD Students
//
//  Created by Voltage on 6/12/15.
//  Copyright © 2015 Gabriel Revells. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		let navigationController = self.viewControllers[self.viewControllers.count-1] as! UINavigationController
		navigationController.topViewController!.navigationItem.leftBarButtonItem = self.displayModeButtonItem()
		self.delegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
		self.preferredDisplayMode = UISplitViewControllerDisplayMode.Automatic
		
		let masterNavigationController = self.viewControllers[0] as! UINavigationController
		let controller = masterNavigationController.topViewController as! WeekTableViewController
		controller.managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
