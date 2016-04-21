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
            Schedule.defaultSchedule.saveToUserDefaults()
        }
        selectedDay = getDayOfWeek()
        let path: NSIndexPath = NSIndexPath(forRow: selectedDay, inSection: 0)
        self.daysOfWeekTable.selectRowAtIndexPath(path, animated: false, scrollPosition: .None)
        self.tableView(self.daysOfWeekTable, didSelectRowAtIndexPath: path)
        self.daysOfWeekTable.estimatedRowHeight = self.daysOfWeekTable.frame.height / 7
        self.scheduleTable.estimatedRowHeight = self.scheduleTable.frame.height / 10
        self.daysOfWeekTable.rowHeight = UITableViewAutomaticDimension
        self.scheduleTable.rowHeight = UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.daysOfWeekTable) {
            return 7
        } else {
            return 10
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
            var cell = tableView.dequeueReusableCellWithIdentifier(id) as! MGSwipeTableCell!
            if cell == nil {
                cell = MGSwipeTableCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: id)
            }
            let date = TimePeriod.getDate(selectedDay + 1, hour: (2 * indexPath.row + 6) % 24)
            let show = Schedule.defaultSchedule.getShow(on: date)
            let period = show?.playingAtPeriod(date)
            if let p = period {
                cell.detailTextLabel!.text = show?.getTimeString(p) ?? ""
            } else {
                cell.detailTextLabel!.text = ""
            }
            cell.textLabel!.text = show?.name ?? ""
            cell.backgroundColor = tableView.backgroundView?.backgroundColor
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.detailTextLabel?.textColor = UIColor.whiteColor()
            cell.delegate = self
            //configure right buttons
            cell.rightButtons = [
                MGSwipeButton(title: "Info", backgroundColor: UIColor.darkGrayColor()),
                MGSwipeButton(title: "Favorite", backgroundColor: UIColor.lightGrayColor())
            ]
            cell.rightSwipeSettings.transition = .Drag
            cell.selectionStyle = .None
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
    
    func swipeTableCell(cell: MGSwipeTableCell!, shouldHideSwipeOnTap point: CGPoint) -> Bool {
        return true
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, tappedButtonAtIndex index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        if (index == 0) { // Info
            //
        } else { // Favorite
            
        }
        return true
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, canSwipe direction: MGSwipeDirection) -> Bool {
        return cell.textLabel!.text != ""
    }
    
}
