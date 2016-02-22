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
    
    var schedule : [[String]]!
    
    // Gets the current weeks schedule from the WTBU website.
    func getSchedule() {
        
        Alamofire.request(.GET, "http://www.wtburadio.org/programming/")
            .responseString{ response in
                if let source = response.result.value {
                    if let doc = Kanna.HTML(html: source, encoding: NSUTF8StringEncoding) {
                        for item in doc.css("table.table-pro") {
                            self.schedule = []
                            if let text = item.text {
                                let blocks = text.componentsSeparatedByString("\n\n\n")
                                var first = true
                                for block in blocks { // For each day of the week, except the first
                                    if first {
                                        first = false
                                        continue
                                    }
                                    var items = [String]()
                                    let splitstring = block.componentsSeparatedByString("\n")
                                    items.appendContentsOf(splitstring)
                                    items.removeFirst()
                                    self.schedule.append(items)
                                }
                                break
                            }
                        }
                        log.debug("Finished parsing schedule website html.")
                    } else {
                        log.debug("Unable to parse schedule site HTML.")
                    }
                } else {
                    log.debug("Source not found.")
                }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSchedule()
        
        // Do any additional setup after loading the view.
        daysOfWeekTable.dataSource = self
        daysOfWeekTable.delegate = self
        
        log.debug("\(self.daysOfWeekTable.bounds.height)")
        
        self.daysOfWeekTable.rowHeight = (self.daysOfWeekTable.bounds.height + 68) / CGFloat(daysOfWeek.count)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysOfWeek.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("dayofweekcell")!
        (cell.subviews.first!.subviews.first as! UILabel).text! = daysOfWeek[indexPath.row]
        return cell
    }
    
}
