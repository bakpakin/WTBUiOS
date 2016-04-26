//
//  TimePeriod.swift
//  WTBUiOS
//
//  Created by Calvin Rose on 4/17/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import Foundation

private let oneDay: NSTimeInterval = 60 * 60 * 24
private let oneWeek: NSTimeInterval = oneDay * 7
private let dateFormatter = makeDateFormatter()
private let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
private let firstNormalDate = makeNewNormalDate("00:00:00", dayOfWeek: 1)
private let lastNormalDate = firstNormalDate.dateByAddingTimeInterval(oneWeek)
private let firstNormalDateValue = firstNormalDate.timeIntervalSinceReferenceDate
private let lastNormalDateValue = lastNormalDate.timeIntervalSinceReferenceDate

private func makeDateFormatter() -> NSDateFormatter {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    return formatter
}

private func makeNewNormalDate(formatString: String, dayOfWeek: Int) -> NSDate {
    return dateFormatter.dateFromString(formatString)!.dateByAddingTimeInterval(oneDay * NSTimeInterval(dayOfWeek % 7))
}

private func makeDate(dayOfWeek: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) -> NSDate {
    let hourString = String(format: "%02d", hour)
    let minuteString = String(format: "%02d", minute)
    let secondString = String(format: "%02d", second)
    let formatString = "\(hourString):\(minuteString):\(secondString)"
    return makeNewNormalDate(formatString, dayOfWeek: dayOfWeek)
}

// Removes the date component of an NSDate, keeping only the time and the day of the week
private func normalizeDate(date: NSDate) -> NSDate {
    let dv = date.timeIntervalSinceReferenceDate
    if dv >= firstNormalDateValue && dv < lastNormalDateValue {
        return date
    }
    let weekDay = calendar.components(.Weekday, fromDate: date).weekday
    let hour = calendar.components(.Hour, fromDate: date).hour
    let minute = calendar.components(.Minute, fromDate: date).minute
    let second = calendar.components(.Second, fromDate: date).second
    return makeDate(weekDay, hour: hour, minute: minute, second: second)
}

final class TimePeriod : NSObject, NSCoding {
    
    static func dateToWeekdayAndTime(date: NSDate) -> NSDate {
        return normalizeDate(date)
    }
    
    static func getDate(dayOfWeek: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) -> NSDate {
        return makeDate(dayOfWeek, hour: hour, minute: minute, second: second)
    }
    
    let start: NSDate
    let length: NSTimeInterval
    let startDay: Int
    let repeatsWeekly: Bool
    private let startNormalized: Bool
    
    // Constructor that works well with the Spinitron JSON data.
    init(startTimeString: String, endTimeString: String, weekday: Int, repeatsWeekly: Bool = true) {
        let startDate = dateFormatter.dateFromString(startTimeString)!
        let endDate = dateFormatter.dateFromString(endTimeString)!
        let myLength = endDate.timeIntervalSinceDate(startDate)
        if myLength < 0 {
            length = myLength + oneDay
        } else {
            length = myLength
        }
        start = startDate.dateByAddingTimeInterval(oneDay * NSTimeInterval(weekday % 7))
        startDay = weekday
        self.repeatsWeekly = repeatsWeekly
        startNormalized = true
    }
    
    init(start: NSDate, length: NSTimeInterval, repeatsWeekly: Bool = true) {
        self.start = start
        self.length = length
        self.repeatsWeekly = repeatsWeekly
        self.startDay = calendar.components(.Weekday, fromDate: start).weekday
        startNormalized = false
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(start, forKey: "start")
        aCoder.encodeDouble(length, forKey: "length")
        aCoder.encodeInteger(startDay, forKey: "startDay")
        aCoder.encodeBool(repeatsWeekly, forKey: "repeatsWeekly")
        aCoder.encodeBool(startNormalized, forKey: "startNormalized")
    }
    
    required init(coder decoder: NSCoder) {
        start = decoder.decodeObjectForKey("start") as! NSDate
        length = decoder.decodeDoubleForKey("length")
        startDay = decoder.decodeIntegerForKey("startDay")
        repeatsWeekly = decoder.decodeBoolForKey("repeatsWeekly")
        startNormalized = decoder.decodeBoolForKey("startNormalized")
    }
    
    // Checks if this TimePeriod overlaps with the given NSDate.
    func contains(date: NSDate? = nil) -> Bool {
        let dt = date ?? NSDate.init(timeIntervalSinceNow: 0)
        if repeatsWeekly {
            if (length >= oneWeek) {
                return true
            }
            let dtNormalized = normalizeDate(dt)
            let startN = startNormalized ? start : normalizeDate(start)
            let delta = dtNormalized.timeIntervalSinceDate(startN)
            if delta < 0 {
                return (delta + oneWeek) < length
            } else {
                return delta < length
            }
        } else {
            return dt.timeIntervalSinceDate(start) < length
        }
    }
    
    private func hour24to12(hour: Int) -> String {
        switch hour {
        case 0:
            return "12AM"
        case 1..<12:
            return "\(hour)AM"
        case 12:
            return "12PM"
        default:
            return "\(hour - 12)PM"
        }
    }
    
    func getHourlyShorthand() -> String {
        let end = start.dateByAddingTimeInterval(length)
        let startHour = calendar.components(.Hour, fromDate: start).hour
        let endHour = calendar.components(.Hour, fromDate: end).hour
        return "\(hour24to12(startHour)) - \(hour24to12(endHour))"
    }
    
    
    func nextDate(date: NSDate? = nil) -> NSDate? {
        let dt = date ?? NSDate()
        if repeatsWeekly {
            let dtNormalized = normalizeDate(dt)
            let startN = startNormalized ? start : normalizeDate(start)
            let delta = startN.timeIntervalSinceDate(dtNormalized)
            if delta > 0 {
                return dt.dateByAddingTimeInterval(delta)
            } else {
                return dt.dateByAddingTimeInterval(oneWeek - delta)
            }
        } else {
            if start.timeIntervalSinceDate(dt) > 0 {
                return start
            } else {
                return nil
            }
        }
    }
    
}