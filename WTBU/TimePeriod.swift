//
//  TimePeriod.swift
//  WTBUiOS
//
//  Created by Calvin Rose on 4/17/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import Foundation

private let oneDay: TimeInterval = 60 * 60 * 24
private let oneWeek: TimeInterval = oneDay * 7
private let dateFormatter = makeDateFormatter()
private let calendar: Calendar = Calendar(identifier: .gregorian)
private let firstNormalDate = makeNewNormalDate(formatString: "00:00:00", dayOfWeek: 1)
private let lastNormalDate = firstNormalDate.addingTimeInterval(oneWeek)
private let firstNormalDateValue = firstNormalDate.timeIntervalSinceReferenceDate
private let lastNormalDateValue = lastNormalDate.timeIntervalSinceReferenceDate

private func makeDateFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    return formatter
}

private func makeNewNormalDate(formatString: String, dayOfWeek: Int) -> Date {
    return dateFormatter.date(from: formatString)!.addingTimeInterval(oneDay * TimeInterval(dayOfWeek % 7))
}

private func makeDate(dayOfWeek: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date {
    let hourString = String(format: "%02d", hour)
    let minuteString = String(format: "%02d", minute)
    let secondString = String(format: "%02d", second)
    let formatString = "\(hourString):\(minuteString):\(secondString)"
    return makeNewNormalDate(formatString: formatString, dayOfWeek: dayOfWeek)
}

// Removes the date component of an NSDate, keeping only the time and the day of the week
private func normalizeDate(date: Date) -> Date {
    let dv = date.timeIntervalSinceReferenceDate
    if dv >= firstNormalDateValue && dv < lastNormalDateValue {
        return date
    }
    let components = calendar.dateComponents([.hour, .minute, .weekday, .second], from: date)
    return makeDate(dayOfWeek: components.weekday!, hour: components.hour!, minute: components.minute!, second: components.second!)
}

class TimePeriod : NSObject, NSCoding {
    
    static func dateToWeekdayAndTime(date: Date) -> Date {
        return normalizeDate(date: date)
    }
    
    static func getDate(dayOfWeek: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date {
        return makeDate(dayOfWeek: dayOfWeek, hour: hour, minute: minute, second: second)
    }
    
    let start: Date
    let length: TimeInterval
    let startDay: Int
    let repeatsWeekly: Bool
    private let startNormalized: Bool
    
    // Constructor that works well with the Spinitron JSON data.
    init(startTimeString: String, endTimeString: String, weekday: Int, repeatsWeekly: Bool = true) {
        let startDate = dateFormatter.date(from: startTimeString)!
        let endDate = dateFormatter.date(from: endTimeString)!
        let myLength = endDate.timeIntervalSince(startDate)
        if myLength < 0 {
            length = myLength + oneDay
        } else {
            length = myLength
        }
        start = startDate.addingTimeInterval(oneDay * TimeInterval(weekday % 7))
        startDay = weekday
        self.repeatsWeekly = repeatsWeekly
        startNormalized = true
    }
    
    init(start: Date, length: TimeInterval, repeatsWeekly: Bool = true) {
        self.start = start
        self.length = length
        self.repeatsWeekly = repeatsWeekly
        self.startDay = calendar.dateComponents([.weekday], from: start).weekday!
        startNormalized = false
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(start, forKey: "start")
        aCoder.encode(length, forKey: "length")
        aCoder.encode(startDay, forKey: "startDay")
        aCoder.encode(repeatsWeekly, forKey: "repeatsWeekly")
        aCoder.encode(startNormalized, forKey: "startNormalized")
    }
    
    required init(coder decoder: NSCoder) {
        start = decoder.decodeObject(forKey: "start") as! Date
        length = decoder.decodeDouble(forKey: "length")
        startDay = decoder.decodeInteger(forKey: "startDay")
        repeatsWeekly = decoder.decodeBool(forKey: "repeatsWeekly")
        startNormalized = decoder.decodeBool(forKey: "startNormalized")
    }
    
    // Checks if this TimePeriod overlaps with the given NSDate.
    func contains(date: Date? = nil) -> Bool {
        let dt = date ?? Date.init(timeIntervalSinceNow: 0)
        if repeatsWeekly {
            if (length >= oneWeek) {
                return true
            }
            let dtNormalized = normalizeDate(date: dt)
            let startN = startNormalized ? start : normalizeDate(date: start)
            let delta = dtNormalized.timeIntervalSince(startN)
            if delta < 0 {
                return (delta + oneWeek) < length
            } else {
                return delta < length
            }
        } else {
            return dt.timeIntervalSince(start) < length
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
        let end = start.addingTimeInterval(length)
        let startComponents = calendar.dateComponents([.hour], from: start)
        let endComponents = calendar.dateComponents([.hour], from: end)
        return "\(hour24to12(hour: startComponents.hour!)) - \(hour24to12(hour: endComponents.hour!))"
    }
    
    func getNextDate() -> Date? {
        if repeatsWeekly {
            let now = Date()
            let nowN = normalizeDate(date: now)
            let startN = startNormalized ? start : normalizeDate(date: start)
            let dt = startN.timeIntervalSince(nowN)
            if dt < 0 { // next week
                return now.addingTimeInterval(oneWeek + dt)
            } else { // this week
                return now.addingTimeInterval(dt)
            }
        } else {
            if start.timeIntervalSinceNow > 0 {
                return start
            } else {
                return nil
            }
        }
    }
    
}
