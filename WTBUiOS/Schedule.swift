//
//  Schedule.swift
//  WTBUiOS
//
//  Created by Calvin Rose on 4/17/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class Schedule {
    
    static let defaultSchedule: Schedule = Schedule()
    
    var shows: [Show] = []
    
    func loadFavoritesData() -> Bool {
        // TODO
        return true
    }
    
    func saveToUserDefaults() -> Bool {
        // TODO
        return true
    }
    
    func loadFromUserDefaults(callback: ((Schedule)->Void)?) -> Bool {
        // Should return false if data is too old
        // TODO
        return false
    }
    
    func loadFromBackend(callback: ((Schedule)->Void)?) {
        Alamofire.request(.GET, "https://gaiwtbubackend.herokuapp.com/regularShowsInfo").responseJSON {
            response in
            if let nativeJson = response.result.value {
                let json = JSON(nativeJson)
                if let results = json["results"].array {
                    var foundShows = Set<Int>()
                    for showJson in results {
                        let show = Show(json: showJson)
                        if !foundShows.contains(show.id) {
                            self.shows.append(Show(json: showJson))
                            foundShows.insert(show.id)
                        }
                    }
                    if let cb = callback {
                        return cb(self)
                    }
                } else {
                    log.debug("Unable to read results from backend.")
                }
            } else {
                log.debug("Unable to load schedule from backend.")
            }
        }
    }
    
    func load(callback: ((Schedule)->Void)?) {
        if !loadFromUserDefaults(callback) {
            loadFromBackend(callback)
        }
    }
    
    // Make sure that no two shows overlap, etc.
    func validate() -> Bool {
        return true
    }
    
    func getShow(on date: NSDate) -> Show? {
        let dt = TimePeriod.dateToWeekdayAndTime(date)
        for show in shows {
            if show.isPlayingAt(dt) {
                return show
            }
        }
        return nil
    }
    
    func getShow(onDayOfWeek: Int, atHour: Int) -> Show? {
        return getShow(on: TimePeriod.getDate(onDayOfWeek, hour: atHour))
    }
    
}