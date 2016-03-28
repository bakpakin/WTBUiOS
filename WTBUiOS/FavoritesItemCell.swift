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
        var favShowsSet = [String]()
        if(defaults.objectForKey("favoriteShows") != nil)
        {
            favShowsSet = defaults.objectForKey("favoriteShows") as! [String]

        }
        if(favoriteSwitch!.on)
        {
            favShowsSet.append((textlabel?.text)!)
            print("ADD")
            print(favShowsSet)
        }
        else
        {
            let index = favShowsSet.indexOf((textlabel?.text)!)
            if(index != nil)
            {
                favShowsSet.removeAtIndex(index!)
            }
        }
        defaults.setObject(favShowsSet, forKey: "favoriteShows")
        defaults.synchronize()
    
    }
}