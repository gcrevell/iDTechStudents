//
//  LoginViewController.swift
//  iD Students
//
//  Created by Voltage on 6/12/15.
//  Copyright © 2015 Gabriel Revells. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate {
	
	var password: String!
	let defaults = NSUserDefaults()
	var enteredPassword = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		
		password = defaults.objectForKey("PASSWORD") as? String
		
		let context = LAContext()
		
		if password == nil {
			var text = ""
			do {
				try context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics)
				text = " After this time you will be able to login with Touch ID."
			} catch {
				print("Unable to authenticate user", appendNewline: true)
				print(error, appendNewline: true)
			}
			
			let alert = UIAlertView(title: "Please enter a password", message: "Please enter a password to protect your data.\(text)", delegate: self, cancelButtonTitle: "Done")
			alert.alertViewStyle = UIAlertViewStyle.SecureTextInput
			alert.textFieldAtIndex(0)?.keyboardType = UIKeyboardType.NumberPad
			alert.show()
		} else {
			
			do {
				try context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics)
				
				//This line will probably break in the future as it still uses the old NSError
				context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "Please sign in to view your students private information", reply: { (success: Bool, error: NSError?) in
					if success {
						self.performSegueWithIdentifier("segueToMainScreen", sender: self)
						return
					} else {
						print(error?.localizedDescription, appendNewline: true)
						
						switch error!.code {
							
						case LAError.SystemCancel.rawValue:
							print("Authentication was cancelled by the system", appendNewline: true)
							
						case LAError.UserCancel.rawValue:
							print("Authentication was cancelled by the user", appendNewline: true)
							
						case LAError.UserFallback.rawValue:
							print("User selected to enter custom password", appendNewline: true)
							
						default:
							print("Authentication failed", appendNewline: true)
						}
					}
				})
			} catch {
				print("Unable to authenticate user", appendNewline: true)
				print(error, appendNewline: true)
			}
		}
	}
	
	func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
		let pass = alertView.textFieldAtIndex(0)!.text
		if pass?.characters.count < 4 {
			let alert = UIAlertView(title: "Please enter a password", message: "Please enter a password to protect your data. The length must be 4 or longer.", delegate: self, cancelButtonTitle: "Done")
			alert.alertViewStyle = UIAlertViewStyle.SecureTextInput
			alert.textFieldAtIndex(0)?.keyboardType = UIKeyboardType.NumberPad
			alert.show()
		} else {
			defaults.setObject(alertView.textFieldAtIndex(0)!.text, forKey: "PASSWORD")
			defaults.synchronize()
			
			self.performSegueWithIdentifier("segueToMainScreen", sender: self)
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func goButtonPressed(sender: AnyObject) {
		if enteredPassword == password {
			self.performSegueWithIdentifier("segueToMainScreen", sender: self)
		} else {
			let alert = UIAlertController(title: "Incorrect password", message: "Please try again", preferredStyle: UIAlertControllerStyle.Alert)
			alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
			self.presentViewController(alert, animated: true, completion: nil)
		}
	}
	
	@IBAction func oneButtonPressed(sender: AnyObject) {
		enteredPassword = "\(enteredPassword)1"
	}
	
	@IBAction func twoButtonPressed(sender: AnyObject) {
		enteredPassword = "\(enteredPassword)2"
	}
	
	@IBAction func threeButtonPressed(sender: AnyObject) {
		enteredPassword = "\(enteredPassword)3"
	}
	
	@IBAction func fourButtonPressed(sender: AnyObject) {
		enteredPassword = "\(enteredPassword)4"
	}
	
	@IBAction func fiveButtonPressed(sender: AnyObject) {
		enteredPassword = "\(enteredPassword)5"
	}
	
	@IBAction func sixButtonPressed(sender: AnyObject) {
		enteredPassword = "\(enteredPassword)6"
	}
	
	@IBAction func sevenButtonPressed(sender: AnyObject) {
		enteredPassword = "\(enteredPassword)7"
	}
	
	@IBAction func eightButtonPressed(sender: AnyObject) {
		enteredPassword = "\(enteredPassword)8"
	}
	
	@IBAction func nineButtonPressed(sender: AnyObject) {
		enteredPassword = "\(enteredPassword)9"
	}
	
	@IBAction func zeroButtonPressed(sender: AnyObject) {
		enteredPassword = "\(enteredPassword)0"
	}
	
}
