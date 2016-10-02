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
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encodeCInt(Int32(id), forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(showDescription, forKey: "showDescription")
        aCoder.encode(showTimes, forKey: "showTimes")
        aCoder.encode(djs, forKey: "djs")
        aCoder.encode(favorited, forKey: "favorited")
    }
    
    required public init(coder decoder: NSCoder) {
        id = Int(decoder.decodeCInt(forKey: "id"))
        name = decoder.decodeObject(forKey: "name") as! String
        url = decoder.decodeObject(forKey: "url") as! String
        showDescription = decoder.decodeObject(forKey: "showDescription") as! String
        showTimes = decoder.decodeObject(forKey: "showTimes") as! [TimePeriod]
        djs = decoder.decodeObject(forKey: "djs") as! [DJ]
        favorited = decoder.decodeBool(forKey: "favorited")
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
                let name = dj["DJName"].string ?? "An Unamed Grandmaster Flash"
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
    
    func playingAtPeriod(date: Date) -> TimePeriod? {
        let dt = TimePeriod.dateToWeekdayAndTime(date: date)
        for period in showTimes {
            if period.contains(date: dt) {
                return period
            }
        }
        return nil
    }
    
}
