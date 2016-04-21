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

public class Show : NSObject, NSCoding {
    
    let id: Int
    let name: String
    var url: String
    var showDescription: String
    var showTimes: [TimePeriod]
    var djs: [DJ]
    var favorited: Bool = false
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
        url = ""
        showDescription = ""
        showTimes = []
        djs = []
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInt(Int32(id), forKey: "id")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(url, forKey: "url")
        aCoder.encodeObject(showDescription, forKey: "showDescription")
        aCoder.encodeObject(showTimes, forKey: "showTimes")
        aCoder.encodeObject(djs, forKey: "djs")
        aCoder.encodeBool(favorited, forKey: "favorited")
    }
    
    required public init(coder decoder: NSCoder) {
        id = Int(decoder.decodeIntForKey("id"))
        name = decoder.decodeObjectForKey("name") as! String
        url = decoder.decodeObjectForKey("url") as! String
        showDescription = decoder.decodeObjectForKey("showDescription") as! String
        showTimes = decoder.decodeObjectForKey("showTimes") as! [TimePeriod]
        djs = decoder.decodeObjectForKey("djs") as! [DJ]
        favorited = decoder.decodeBoolForKey("favorited")
    }

    // Initialized a show from JSON given from the backend.
    init(json: JSON) {
        let timeStartString = json["OnairTime"].string ?? "00:00:00"
        let timeEndString = json["OffairTime"].string ?? "02:00:00"
        
        id = json["ShowID"].int ?? -1
        name = json["ShowName"].string ?? "Unamed Show"
        url = json["ShowUrl"].string ?? ""
        showDescription = json["ShowDescription"].string ?? ""
        
        var temp_djs = [DJ]()
        if let djsJson = json["ShowUsers"].array {
            for dj in djsJson {
                let id = dj["UserID"].int ?? -1
                let name = dj["DJName"].string ?? "Unamed Grandmaster Flash"
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
    
    func playingAtPeriod(date: NSDate) -> TimePeriod? {
        let dt = TimePeriod.dateToWeekdayAndTime(date)
        for period in showTimes {
            if period.contains(dt) {
                return period
            }
        }
        return nil
    }
    
}