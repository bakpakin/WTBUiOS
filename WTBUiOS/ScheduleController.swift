//
//  ScheduleController.swift
//  WTBUiOS
//
//  Created by Calvin Rose on 2/21/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import Foundation
import UIKit
import MGSwipeTableCell

class ScheduleController : AllViewController, UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate {
    
    @IBOutlet weak var daysOfWeekTable: UITableView!
    @IBOutlet weak var scheduleTable: UITableView!
    
    var selectedDay : Int = 0
    
    // Get the current day of the week
    func getDayOfWeek()->Int {
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let components = myCalendar!.components(.Weekday, fromDate: NSDate())
        return components.weekday - 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Schedule.defaultSchedule.load() {
            schedule in
            self.scheduleTable.reloadData()
        }
        selectedDay = getDayOfWeek()
        let path: NSIndexPath = NSIndexPath(forRow: selectedDay, inSection: 0)
        self.daysOfWeekTable.selectRowAtIndexPath(path, animated: false, scrollPosition: .None)
        self.tableView(self.daysOfWeekTable, didSelectRowAtIndexPath: path)
        
        let show = Schedule.defaultSchedule.getCurrentShow()
        log.debug(show?.debugDescription)
        
        let notification = UILocalNotification()
        notification.fireDate = NSDate().dateByAddingTimeInterval(4)
        notification.alertBody = "Notifications are on air!"
        notification.repeatInterval = NSCalendarUnit.Weekday
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.daysOfWeekTable) {
            return 7
        } else {
            return 10
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == self.daysOfWeekTable {
            return tableView.bounds.height / 7
        } else {
            return tableView.bounds.height / 10
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == self.daysOfWeekTable {
            let cell = tableView.cellForRowAtIndexPath(indexPath)!
            cell.imageView!.image = UIImage(named: "di\(indexPath.row)")
            selectedDay = indexPath.row
            self.scheduleTable.reloadData()
        } else {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! MGSwipeTableCell
            if cell.textLabel!.text != "" {
                cell.showSwipe(.RightToLeft, animated: true)
            }
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == self.daysOfWeekTable {
            let cell = tableView.cellForRowAtIndexPath(indexPath)!
            cell.imageView!.image = UIImage(named: "d\(indexPath.row)")
        }
    }
    
    func getDateForIndexPath(path: NSIndexPath) -> NSDate {
        return TimePeriod.getDate(selectedDay + 1, hour: (2 * path.row + 6) % 24)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (tableView == self.daysOfWeekTable) {
            let id = "dayofweekcell"
            var cell = tableView.dequeueReusableCellWithIdentifier(id) as UITableViewCell!
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: id)
            }
            cell.backgroundColor = tableView.backgroundColor
            cell.imageView!.image = UIImage(named: "d\(indexPath.row)")
            cell.selectionStyle = .None
            return cell
        } else {
            let id = "scheduleitemcell"
            let date = getDateForIndexPath(indexPath)
            let show = Schedule.defaultSchedule.getShow(on: date)
            let period = show?.playingAtPeriod(date)
            var cell = tableView.dequeueReusableCellWithIdentifier(id) as! ScheduleItemCell!
            if cell == nil {
                cell = ScheduleItemCell(reuseIdentifier: id)
            }
            cell.setup(show, period: period)
            cell.delegate = self
            return cell
        }
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, shouldHideSwipeOnTap point: CGPoint) -> Bool {
        return true
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, tappedButtonAtIndex index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        if (index == 0) { // Favorite
            if let c = cell as! ScheduleItemCell! {
                if let show = c.show {
                    show.favorited = !show.favorited
                    Schedule.defaultSchedule.saveFavorites()
                    c.dataUpdated()
                }
            }
        }
        return true
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, canSwipe direction: MGSwipeDirection) -> Bool {
        return cell.textLabel!.text != ""
    }
    
}
