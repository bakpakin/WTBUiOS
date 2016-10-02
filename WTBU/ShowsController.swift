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
import XCGLogger

class ShowsController : UIViewController, UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate {
    
    @IBOutlet weak var daysOfWeekTable: UITableView!
    @IBOutlet weak var scheduleTable: UITableView!
    
    var selectedDay : Int = 0
    
    // Get the current day of the week
    func getDayOfWeek() -> Int {
        let myCalendar = Calendar(identifier: .gregorian)
        let components = myCalendar.dateComponents([.weekday], from: Date())
        return components.weekday! - 1
    }
    
    func getDateForIndexPath(path: IndexPath) -> Date {
        return TimePeriod.getDate(dayOfWeek: selectedDay + 1, hour: (2 * path.row + 6) % 24)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Schedule.defaultSchedule.load() {
            schedule in
            self.scheduleTable.reloadData()
            Schedule.defaultSchedule.saveToUserDefaults()
        }
        selectedDay = getDayOfWeek()
        let path: IndexPath = IndexPath(row: selectedDay, section: 0)
        self.daysOfWeekTable.selectRow(at: path, animated: false, scrollPosition: .none)
        self.tableView(self.daysOfWeekTable, didSelectRowAt: path)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.daysOfWeekTable) {
            return 7
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.daysOfWeekTable {
            // We shouldn't need the -5 but I can't figure out why the cells come out to large.
            // There might be some extra padding between cells, at the ends of the cells, or 
            // a resize might need to be trigger (the resize didn't help)
            return (tableView.bounds.height / 7) - 5
        } else {
            return tableView.bounds.height / 10
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.daysOfWeekTable {
            let cell = tableView.cellForRow(at: indexPath)!
            cell.imageView!.image = UIImage(named: "di\(indexPath.row)")
            selectedDay = indexPath.row
            self.scheduleTable.reloadData()
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! MGSwipeTableCell
            if cell.textLabel!.text != "" {
                cell.showSwipe(.rightToLeft, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView == self.daysOfWeekTable {
            Schedule.defaultSchedule.saveToUserDefaults()
            let cell = tableView.cellForRow(at: indexPath)!
            cell.imageView!.image = UIImage(named: "d\(indexPath.row)")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == self.daysOfWeekTable) {
            let id = "dayofweekcell"
            var cell = tableView.dequeueReusableCell(withIdentifier: id) as UITableViewCell!
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: id)
            }
            cell?.backgroundColor = tableView.backgroundColor
            cell?.imageView!.image = UIImage(named: "d\(indexPath.row)")
            cell?.selectionStyle = .none
            return cell!
        } else {
            let id = "scheduleitemcell"
            let date = getDateForIndexPath(path: indexPath)
            let show = Schedule.defaultSchedule.getShow(on: date)
            let period = show?.playingAtPeriod(date: date)
            var cell = tableView.dequeueReusableCell(withIdentifier: id) as! ScheduleItemCell!
            if cell == nil {
                cell = ScheduleItemCell(reuseIdentifier: id)
            }
            cell?.setup(show: show, period: period)
            cell?.delegate = self
            return cell!
        }
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, shouldHideSwipeOnTap point: CGPoint) -> Bool {
        return true
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, tappedButtonAt index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
//        if (index == 0) { // Info
//            XCGLogger.default.debug("Info button touched.")
//        } else { // Favorite
            if let c = cell as? ScheduleItemCell {
                if let show = c.show {
                    show.favorited = !show.favorited
                    c.dataUpdated()
                }
            }
//        }
        return true
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, canSwipe direction: MGSwipeDirection) -> Bool {
        return cell.textLabel!.text != ""
    }
    
}
