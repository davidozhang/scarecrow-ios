//
//  ViewController.swift
//  Scarecrow
//
//  Created by David on 11/21/15.
//  Copyright © 2015 David Zhang. All rights reserved.
//

import UIKit
import LocalAuthentication
import Alamofire

let authenticatedKey = "authenticated"
let unauthenticatedKey = "unauthenticated"

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var devices = ["device_1", "device_2", "device_3"]

    @IBOutlet var status: UIView!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var devicesCollection: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setAuthenticated", name: authenticatedKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setUnauthenticated", name: unauthenticatedKey, object: nil)
        devicesCollection.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.7)
        hideDevices()
        setUnauthenticated()
        authenticateWithTouchID()
    }

    func httpGet(url: String) {
        Alamofire.request(.GET, url)
            .responseJSON { response in
                return response.result.value
        }
    }
    
    func httpPost(url: String, parameters: [String: String]) {
        Alamofire.request(.POST, url, parameters: parameters)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return devices.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: CollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! CollectionViewCell
        cell.name.text = devices[indexPath.row]
        return cell
    }
    
    func setUnauthenticated() {
        status.backgroundColor = UIColor(red: 0.9, green: 0, blue: 0, alpha: 0.6)
        statusLabel.text = "Unauthenticated"
    }
    
    func setAuthenticated() {
        status.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 0.6)
        statusLabel.text = "Authenticated"
        
        let parameters = ["": ""]
        httpPost("http://192.168.64.205:8080/auth", parameters: parameters)
    }
    
    func showDevices() {
        devicesCollection.hidden = false
    }
    
    func hideDevices() {
        devicesCollection.hidden = true
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
                        self.showDevices()
                    })
                } else {
                    self.showAlert("Scarecrow authentication failed")
                    dispatch_async(dispatch_get_main_queue(), {
                        NSNotificationCenter.defaultCenter().postNotificationName("unauthenticated", object: nil)
                        self.hideDevices()
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

