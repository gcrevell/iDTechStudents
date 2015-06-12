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
	
	@IBOutlet weak var pinTextField: UITextField!
	var password: String!
	let defaults = NSUserDefaults()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		pinTextField.delegate = self
		
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
			} catch {
				print("Unable to authenticate user", appendNewline: true)
				print(error, appendNewline: true)
			}
			
			//This line will probably break in the future as it still uses the old NSError
			context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "Please sign in to view your students private information", reply: { (success: Bool, error: NSError?) in
				if success {
					self.performSegueWithIdentifier("segueToMainScreen", sender: self)
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
		}
	}
	
	func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
		defaults.setObject(alertView.textFieldAtIndex(0)!.text, forKey: "PASSWORD")
		defaults.synchronize()
		
		self.performSegueWithIdentifier("segueToMainScreen", sender: self)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func goButtonPressed(sender: AnyObject) {
		//let split = self.storyboard?.instantiateViewControllerWithIdentifier("split")
		//self.view.window!.rootViewController = split;
		pinTextField.resignFirstResponder()
		
		if pinTextField.text == password {
			self.performSegueWithIdentifier("segueToMainScreen", sender: self)
		}
	}
	
}
