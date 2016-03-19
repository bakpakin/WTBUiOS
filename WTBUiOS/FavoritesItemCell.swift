//
//  FavoritesItemCell.swift
//  WTBUiOS
//
//  Created by Calvin Rose on 3/19/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import Foundation
import UIKit

class FavoritesItemCell : UITableViewCell {
    
    weak var textlabel: UILabel?
    
    // Add some custom stuff here.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        for subview in self.subviews.first!.subviews {
            if subview is UILabel {
                textlabel = subview as? UILabel
                break
            }
        }
    }
    
}
