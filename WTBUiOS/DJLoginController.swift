//
//  DJLoginController.swift
//  WTBUiOS
//
//  Created by Calvin Rose on 4/26/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

class DJLoginController : AllViewController {
    
    @IBOutlet weak var chatnameField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func login(sender: AnyObject) {
        if let requestedLoginName = chatnameField.text {
            if requestedLoginName != "" {
                let parameters = [
                    "name": requestedLoginName
                ]
                Alamofire.request(.GET, "https://gaiwtbubackend.herokuapp.com/chatSession", parameters: parameters).responseJSON {
                    response in
                    if let jsonNative = response.result.value {
                        let json = JSON(jsonNative)
                        if let token = json["token"].string {
                            log.debug("Token received: \(token)")
                            let name = json["name"].string ?? "No name"
                            (self.parentViewController as! MainChatController!).loginIn(name, token: token)
                        } else {
                            log.debug("Could not get token.")
                        }
                    }
                }
            }
        }
    }
    
}
