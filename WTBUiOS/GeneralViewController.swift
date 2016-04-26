//
//  GeneralViewController.swift
//  WTBUiOS
//
//  Created by Calvin Rose on 4/26/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import Foundation
import UIKit

class GeneralViewController : AllViewController {
    
    @IBOutlet weak var donateButton: UIButton!
    
    @IBAction func donateButtonPressed(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://trusted.bu.edu/s/1759/2-bu/giving.aspx?sid=1759&gid=2&pgid=434&cid=1077&appealcode=WEBCOM")!)
    }
    
}
