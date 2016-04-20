//
//  Show.swift
//  WTBUiOS
//
//  Created by Calvin Rose on 4/17/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import Foundation
import SwiftyJSON

private let weekDaysToInts = [
    "Sun": 1,
    "Mon": 2,
    "Tue": 3,
    "Wed": 4,
    "Thu": 5,
    "Fri": 6,
    "Sat": 7
]

struct Show {
    
    let id: Int
    let name: String
    let url: String
    let description: String
    let showTimes: [TimePeriod]
    let djs: [DJ]
    
    init(json: JSON) {
        let timeStartString = json["OnairTime"].string ?? "00:00:00"
        let timeEndString = json["OffairTime"].string ?? "02:00:00"
        
        id = json["ShowID"].int ?? -1
        name = json["ShowName"].string ?? "Unamed Show"
        url = json["ShowUrl"].string ?? ""
        description = json["ShowDescription"].string ?? ""
        
        var temp_djs = [DJ]()
        if let djsJson = json["ShowUsers"].array {
            for dj in djsJson {
                let id = dj["UserID"].int ?? -1
                let name = dj["DJName"].string ?? "Unamed DJ Calvin"
                temp_djs.append(DJ(name: name, bio: nil, id: id))
            }
        }
        djs = temp_djs
        
        var showTimes = [TimePeriod]()
        if let weekdaysJson = json["Weekdays"].array {
            for day in weekdaysJson {
                if let dayNumber = weekDaysToInts[day.string ?? ""] {
                    showTimes.append(TimePeriod(startTimeString: timeStartString, endTimeString: timeEndString, weekday: dayNumber))
                }
            }
        }
        self.showTimes = showTimes
    }
    
    func isPlayingAt(date: NSDate) -> Bool {
        let dt = TimePeriod.dateToWeekdayAndTime(date)
        for period in showTimes {
            if period.contains(dt) {
                return true
            }
        }
        return false
    }
    
}