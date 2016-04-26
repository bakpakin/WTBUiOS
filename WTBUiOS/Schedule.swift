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

public class Schedule : NSObject, NSCoding {
    
    static let defaultSchedule: Schedule = Schedule()
    
    let favoritesKey = "favoriteShows"
    let showsKey = "allShows"
    let lastLoadedFromBackend = "lastLoadedFromBackend"
    
    var shows: [Show]
    
    public override init() {
        shows = []
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(shows, forKey: "shows")
    }
    
    required public init(coder decoder: NSCoder) {
        self.shows = (decoder.decodeObjectForKey("show") as? [Show]) ?? []
    }
    
    private func loadFavoritesData() {
        if let favShows = NSUserDefaults.standardUserDefaults().objectForKey(favoritesKey) as? [Int] {
            for show in shows {
                if favShows.contains(show.id) {
                    show.favorited = true
                }
            }
        }
    }
    
    func saveFavorites() {
        var favorites = [Int]()
        for show in shows {
            if show.favorited {
                favorites.append(show.id)
            }
        }
        NSUserDefaults.standardUserDefaults().setValue(favorites, forKey: favoritesKey)
    }
    
    private func saveToUserDefaults() {
        saveFavorites()
        NSUserDefaults.standardUserDefaults().setValue(NSKeyedArchiver.archivedDataWithRootObject(shows), forKey: showsKey)
    }
    
    private func loadFromUserDefaults() -> Bool {
        if let lastBackendLoad = NSUserDefaults.standardUserDefaults().objectForKey(lastLoadedFromBackend) as? NSDate {
            // If has been less than 3 days since last backend load.
            // This ensures that users don't get really old data.
            if NSDate().timeIntervalSinceDate(lastBackendLoad) < 86400 * 3 {
                if let showsData = NSUserDefaults.standardUserDefaults().objectForKey(showsKey) as? NSData {
                    let shows = NSKeyedUnarchiver.unarchiveObjectWithData(showsData) as? [Show]
                    self.shows = shows ?? []
                    self.loadFavoritesData()
                    return true
                }
            }
        }
        // Remove any potentially bad cache date just in case.
        NSUserDefaults.standardUserDefaults().removeObjectForKey(showsKey)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(lastLoadedFromBackend)
        return false
    }
    
    private func loadFromBackend(callback: ((Schedule)->Void)? = nil) {
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
                    NSUserDefaults.standardUserDefaults().setValue(NSDate(), forKey: self.lastLoadedFromBackend)
                    self.saveToUserDefaults()
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
    
    func load(callback: ((Schedule)->Void)? = nil) {
        if loadFromUserDefaults() {
            if let cb = callback {
                cb(self)
            }
        } else {
            loadFromBackend(callback)
        }
    }
    
    func getCurrentShow() ->Show? {
        return getShow(on: NSDate())
    }
    
    func getShow(on date: NSDate) -> Show? {
        let dt = TimePeriod.dateToWeekdayAndTime(date)
        for show in shows {
            if show.playingAtPeriod(dt) != nil {
                return show
            }
        }
        return nil
    }
    
    func getShow(onDayOfWeek: Int, atHour: Int) -> Show? {
        return getShow(on: TimePeriod.getDate(onDayOfWeek, hour: atHour))
    }
    
    func addNotifications() {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        for show in shows {
            if !show.favorited {
                continue
            }
            for time in show.showTimes {
                let notification = UILocalNotification()
                notification.fireDate = time.nextDate()
                notification.alertBody = "\"\(show.name)\" is on air!"
                notification.repeatInterval = NSCalendarUnit.Weekday
                notification.soundName = UILocalNotificationDefaultSoundName
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            }
        }
    }
    
}