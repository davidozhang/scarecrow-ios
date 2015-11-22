//
//  CollectionViewCell.swift
//  Scarecrow
//
//  Created by David on 11/21/15.
//  Copyright © 2015 David Zhang. All rights reserved.
//

import Alamofire
import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var toggle: UISwitch!
    
    @IBAction func stateChanged(sender: AnyObject) {
        if toggle.on {
            let parameters = [
                "device": String(name.text),
                "setStatus": "on"
            ]
            httpPost("http://192.168.64.205:8080/devices", parameters: parameters)
        } else {
            let parameters = [
                "device": String(name.text),
                "setStatus": "off"
            ]
            httpPost("http://192.168.64.205:8080/devices", parameters: parameters)
        }
    }
    
    func httpPost(url: String, parameters: [String: String]) {
        Alamofire.request(.POST, url, parameters: parameters)
    }
}
