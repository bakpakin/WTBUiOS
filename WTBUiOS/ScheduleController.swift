//
//  ScheduleController.swift
//  WTBUiOS
//
//  Created by Calvin Rose on 2/21/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import Kanna

class ScheduleController : AllViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var daysOfWeekTable: UITableView!
    @IBOutlet weak var scheduleTable: UITableView!
    
    let daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"]
    
    var schedule : [[String]]?
    var selectedDay : Int = 0
    
    // Gets the current weeks schedule from the WTBU website.
    func getSchedule() {
        
        Alamofire.request(.GET, "http://www.wtburadio.org/programming/")
            .responseString{ response in
                if let source = response.result.value {
                    if let doc = Kanna.HTML(html: source, encoding: NSUTF8StringEncoding) {
                        for item in doc.css("table.table-pro") {
                            var s: [[String]] = [[String]]()
                            if let text = item.text {
                                let blocks = text.componentsSeparatedByString("\n\n\n")
                                for block in blocks { // For each day of the week
                                    var items = [String]()
                                    let splitstring = block.componentsSeparatedByString("\n")
                                    items.appendContentsOf(splitstring)
                                    items.removeFirst()
                                    if items.count > 0 {
                                        s.append(items)
                                    }
                                }
                                s.removeFirst()
                                self.schedule = s
                                break
                            }
                        }
                        self.scheduleTable.reloadData()
                        log.debug("Finished parsing schedule website html.")
                    } else {
                        log.debug("Unable to parse schedule site HTML.")
                    }
                } else {
                    log.debug("Source not found.")
                }
        }
        
    }
    
    // Get the current day of the week
    func getDayOfWeek()->Int {
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let components = myCalendar!.components(.WeekdayOrdinal, fromDate: NSDate())
        return components.weekdayOrdinal - 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSchedule()

        selectedDay = getDayOfWeek()
        let path: NSIndexPath = NSIndexPath(forRow: selectedDay, inSection: 0)
        self.daysOfWeekTable.selectRowAtIndexPath(path, animated: false, scrollPosition: .None)
        self.tableView(self.daysOfWeekTable, didSelectRowAtIndexPath: path)
        
        log.debug("\(self.daysOfWeekTable.bounds.height)")
        
        self.daysOfWeekTable.rowHeight = (self.daysOfWeekTable.bounds.height + 68) / CGFloat(daysOfWeek.count)
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
            log.debug("Selected \(indexPath.row)")
            selectedDay = indexPath.row
            self.scheduleTable.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (tableView == self.daysOfWeekTable) {
            let cell = tableView.dequeueReusableCellWithIdentifier("dayofweekcell")!
            (cell.subviews.first!.subviews.first as! UILabel).text! = daysOfWeek[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("scheduleitemcell")!
            if let s = schedule {
                (cell.subviews.first!.subviews.first as! UILabel).text! = s[indexPath.row][self.selectedDay]
            }
            return cell
        }
    }
    
}
