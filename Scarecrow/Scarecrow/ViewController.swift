//
//  ViewController.swift
//  Scarecrow
//
//  Created by David on 11/21/15.
//  Copyright © 2015 David Zhang. All rights reserved.
//

import UIKit
import LocalAuthentication

let authenticatedKey = "authenticated"
let unauthenticatedKey = "unauthenticated"

class ViewController: UIViewController {

    @IBOutlet var status: UIView!
    @IBOutlet var statusLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setAuthenticated", name: authenticatedKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setUnauthenticated", name: unauthenticatedKey, object: nil)
        setUnauthenticated()
        authenticateWithTouchID()
    }

    func setUnauthenticated() {
        status.backgroundColor = UIColor(red: 0.9, green: 0, blue: 0, alpha: 0.6)
        statusLabel.text = "Unauthenticated"
    }
    
    func setAuthenticated() {
        status.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 0.6)
        statusLabel.text = "Authenticated"
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func authenticateWithTouchID() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate for Scarecrow"
            context.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: {(success: Bool, error: NSError?) -> Void in
            
                if success {
                    self.showAlert("Scarecrow successfully authenticated")
                    dispatch_async(dispatch_get_main_queue(), {
                        NSNotificationCenter.defaultCenter().postNotificationName("authenticated", object: nil)
                    })
                } else {
                    self.showAlert("Scarecrow authentication failed")
                    dispatch_async(dispatch_get_main_queue(), {
                        NSNotificationCenter.defaultCenter().postNotificationName("unauthenticated", object: nil)
                    })
                }
            })
        } else {
            showAlert("Touch ID not available. You cannot use Scarecrow.")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

