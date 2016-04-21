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
    weak var favoriteSwitch: UISwitch?
    var switchIndex: Int = 0
    
    // Add some custom stuff here.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        for subview in self.subviews.first!.subviews {
            if subview is UILabel {
                textlabel = subview as? UILabel
            } else if subview is UISwitch {
                favoriteSwitch = subview as? UISwitch
                favoriteSwitch!.setOn(false, animated: false)
            }
        }
    }
    
    func switchToggled() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if(defaults.objectForKey("favoriteShows") != nil)
        {
            favShows = defaults.objectForKey("favoriteShows") as! [String]

        }
        if(favoriteSwitch!.on)
        {
            favShows.append((textlabel?.text)!)
            print("ADD")
            print(favShows)
        }
        else
        {
            let index = favShows.indexOf((textlabel?.text)!)
            if(index != nil)
            {
                favShows.removeAtIndex(index!)
            }
        }
        defaults.setObject(favShows, forKey: "favoriteShows")
        defaults.synchronize()
           
    }
}