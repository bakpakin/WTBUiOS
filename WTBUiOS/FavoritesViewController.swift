//
//  FavoritesViewController.swift
//  WTBUiOS
//
//  Created by Calvin Rose on 3/19/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import Foundation
import UIKit

class FavoritesViewController : AllViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var favoritesTable: UITableView!
    var favShowsSet = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = dataSchedule {
            
        } else {
            dataGetSchedule({ data in
                self.favoritesTable.reloadData()
            })
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if(defaults.objectForKey("favoriteShows") != nil)
        {
            favShowsSet = defaults.objectForKey("favoriteShows") as! [String]
            
        }
        favoritesTable.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("scheduleitemcell") as! FavoritesItemCell
        if let showList = dataShowList {
            let showName = showList[indexPath.row]
            if(favShowsSet.contains(showName))
            {
                print(showName)
                cell.favoriteSwitch!.setOn(true, animated: false)
            }
            else
            {
                cell.favoriteSwitch!.setOn(false, animated: false)
            }
            cell.textlabel!.text = showName
            cell.favoriteSwitch!.addTarget(cell, action: "switchToggled", forControlEvents: .TouchUpInside)
            cell.switchIndex = indexPath.row
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let showList = dataShowList {
            return showList.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
}