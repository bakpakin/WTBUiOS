//
//  AllViewController.swift
//  WTBUiOS
//
//  Created by Ben Cootner on 2/21/16.
//  Copyright © 2016 Ben Cootner. All rights reserved.
//

import Foundation
import UIKit

// Parent class for all custom view controllers

class AllViewController : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}
