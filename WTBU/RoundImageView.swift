//
//  RoundImageView.swift
//  WTBU
//
//  Created by Calvin Rose on 10/2/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import UIKit
import Foundation

class RoundImageView : UIImageView {
    
    override var bounds: CGRect {
        didSet {
            self.setRounded()
        }
    }
    
}
