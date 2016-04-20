//
//  ScheduleController.swift
//  WTBUiOS
//
//  Created by Calvin Rose on 2/21/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import Foundation
import UIKit

class ScheduleController : AllViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var daysOfWeekTable: UITableView!
    @IBOutlet weak var scheduleTable: UITableView!
    
    let daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"]
    
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
            Schedule.defaultSchedule.saveToUserDefaults()
        }
        
        selectedDay = getDayOfWeek()
        let path: NSIndexPath = NSIndexPath(forRow: selectedDay, inSection: 0)
        self.daysOfWeekTable.selectRowAtIndexPath(path, animated: false, scrollPosition: .None)
        self.tableView(self.daysOfWeekTable, didSelectRowAtIndexPath: path)
        
        self.daysOfWeekTable.estimatedRowHeight = self.daysOfWeekTable.bounds.height / 7
        self.daysOfWeekTable.rowHeight = UITableViewAutomaticDimension
        self.scheduleTable.estimatedRowHeight = self.scheduleTable.bounds.height / 10
        self.scheduleTable.rowHeight = UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.daysOfWeekTable) {
            return daysOfWeek.count
        } else {
            return 10
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == self.daysOfWeekTable {
            selectedDay = indexPath.row
            self.scheduleTable.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (tableView == self.daysOfWeekTable) {
            let cell = tableView.dequeueReusableCellWithIdentifier("dayofweekcell") as! DayOfWeekCell
            (cell.subviews.first!.subviews.first as! UILabel).text! = daysOfWeek[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("scheduleitemcell") as! ScheduleItemCell
            let hour1 = ((2 * indexPath.row + 5) % 12) + 1
            let hour2 = ((2 * indexPath.row + 7) % 12) + 1
            let hour = (2 * indexPath.row + 6) % 24
            let timestring = "\(hour1)-\(hour2):"
            let show = Schedule.defaultSchedule.getShow(selectedDay + 1, atHour: hour)
            if let s = show {
                cell.label.text = "\(timestring) \(s.name)"
            } else {
                cell.label.text = "\(timestring)"
            }
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == self.daysOfWeekTable {
            return tableView.bounds.height / 7
        } else {
            return tableView.bounds.height / 10
        }
    }
    
}
